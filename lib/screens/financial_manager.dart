import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/menu_sanduwitch.dart';
import 'package:smartmanager/widgets/dropdown_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Modelo de Lançamento Financeiro
class FinancialEntry {
  final String? documentId;
  final String type; // 'Ativo' ou 'Passivo'
  final String description;
  final double value;
  final String nature; // 'Receita' ou 'Despesa'
  final String recurrence; // 'Único', 'Mensal', 'Semanal', 'Diário', etc.
  final DateTime? dueDate;

  FinancialEntry({
    this.documentId,
    required this.type,
    required this.description,
    required this.value,
    required this.nature,
    required this.recurrence,
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'value': value,
      'nature': nature,
      'recurrence': recurrence,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory FinancialEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FinancialEntry(
      documentId: doc.id,
      type: data['type'] ?? 'Passivo',
      description: data['description'] ?? '',
      value: (data['value'] ?? 0.0).toDouble(),
      nature: data['nature'] ?? 'Despesa',
      recurrence: data['recurrence'] ?? 'Único',
      dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
    );
  }
}

// Widget de Input de Texto com estilo do dropdown_list
class StyledTextInput extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final bool enabled;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final Color? fillColor;
  final EdgeInsets? padding;

  const StyledTextInput({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.fillColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor = borderColor ?? Colors.white;
    final defaultBorderRadius = borderRadius ?? 10.0;
    final defaultBorderWidth = borderWidth ?? 1.0;
    final defaultFillColor = fillColor ?? Colors.white.withOpacity(0.1);
    final defaultPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 20);

    return Padding(
      padding: defaultPadding,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        enabled: enabled,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            borderSide: BorderSide(
              color: defaultBorderColor,
              width: defaultBorderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            borderSide: BorderSide(
              color: defaultBorderColor,
              width: defaultBorderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            borderSide: BorderSide(
              color: defaultBorderColor,
              width: defaultBorderWidth,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            borderSide: BorderSide(
              color: defaultBorderColor.withOpacity(0.5),
              width: defaultBorderWidth,
            ),
          ),
          filled: true,
          fillColor: defaultFillColor,
        ),
      ),
    );
  }
}

class FinancialManager extends StatefulWidget {
  const FinancialManager({super.key});

  @override
  State<FinancialManager> createState() => _FinancialManagerState();
}

class _FinancialManagerState extends State<FinancialManager> {
  // Controllers para os campos
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _typeController = TextEditingController(
    text: 'Passivo',
  );
  final TextEditingController _natureController = TextEditingController(
    text: 'Despesa',
  );
  final TextEditingController _recurrenceController = TextEditingController(
    text: 'Único',
  );
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    _typeController.dispose();
    _natureController.dispose();
    _recurrenceController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<String?> _saveEntryToFirestore(FinancialEntry entry) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não autenticado. Faça login novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }

    try {
      final entryData = entry.toMap();
      entryData['userId'] = currentUser.uid;

      if (entry.documentId != null) {
        await FirebaseFirestore.instance
            .collection('financial_entries')
            .doc(entry.documentId)
            .update(entryData);
        return entry.documentId;
      } else {
        entryData['createdAt'] = FieldValue.serverTimestamp();
        final docRef = await FirebaseFirestore.instance
            .collection('financial_entries')
            .add(entryData);
        return docRef.id;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar lançamento: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  Future<void> _deleteEntryFromFirestore(String documentId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não autenticado. Faça login novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('financial_entries')
          .doc(documentId)
          .delete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir lançamento: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dueDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _saveEntry() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha a descrição.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_valueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o valor.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final value = double.tryParse(_valueController.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um valor válido.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    DateTime? dueDate;
    if (_dueDateController.text.trim().isNotEmpty) {
      try {
        dueDate = DateFormat('dd/MM/yyyy').parse(_dueDateController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data inválida. Use o formato DD/MM/AAAA.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    final entry = FinancialEntry(
      type: _typeController.text,
      description: _descriptionController.text.trim(),
      value: value,
      nature: _natureController.text,
      recurrence: _recurrenceController.text,
      dueDate: dueDate,
    );

    final savedId = await _saveEntryToFirestore(entry);

    if (mounted && savedId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lançamento salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpar campos
      _descriptionController.clear();
      _valueController.clear();
      _typeController.text = 'Passivo';
      _natureController.text = 'Despesa';
      _recurrenceController.text = 'Único';
      _dueDateController.clear();

      // Voltar para a tela anterior após salvar
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      title: '💰 Gestor Financeiro',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha 1: Tipo e Natureza (2 campos)
            Row(
              children: [
                Expanded(
                  child: ClipRect(
                    child: DropdownList(
                      values: ['Ativo', 'Passivo'],
                      initialValue: _typeController.text,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _typeController.text = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRect(
                    child: DropdownList(
                      values: [
                        'Receita',
                        'Despesa',
                        'Jogos',
                        'Academia',
                        'Dieta',
                      ],
                      initialValue: _natureController.text,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _natureController.text = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Linha 2: Descrição (1 campo - full width)
            StyledTextInput(
              labelText: 'Descrição',
              hintText: 'Digite a descrição do lançamento',
              controller: _descriptionController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              borderRadius: 10.0,
              borderColor: Colors.white,
              borderWidth: 1.0,
              fillColor: Colors.white.withOpacity(0.1),
            ),

            // Linha 3: Valor e Recorrência (2 campos)
            Row(
              children: [
                Expanded(
                  child: StyledTextInput(
                    labelText: 'Valor',
                    hintText: '0,00',
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 8,
                      top: 20,
                      bottom: 20,
                    ),
                    borderRadius: 10.0,
                    borderColor: Colors.white,
                    borderWidth: 1.0,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                ),
                Expanded(
                  child: ClipRect(
                    child: DropdownList(
                      values: [
                        'Único',
                        'Diário',
                        'Semanal',
                        'Quinzenal',
                        'Mensal',
                        'Bimestral',
                        'Trimestral',
                        'Semestral',
                        'Anual',
                      ],
                      initialValue: _recurrenceController.text,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _recurrenceController.text = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Linha 4: Vencimento (1 campo - full width)
            GestureDetector(
              onTap: _selectDate,
              child: StyledTextInput(
                labelText: 'Vencimento',
                hintText: 'Selecione a data de vencimento',
                controller: _dueDateController,
                enabled: false,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                borderRadius: 10.0,
                borderColor: Colors.white,
                borderWidth: 1.0,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),

            // Botão Salvar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

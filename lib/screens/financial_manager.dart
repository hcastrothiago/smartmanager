import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Importações de Widgets Reaproveitáveis
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/input_form.dart'; // Importação solicitada
import 'package:smartmanager/widgets/dropdown_list.dart';

// Modelo de Lançamento Financeiro
// Modelo de Lançamento Financeiro atualizado com o Factory necessário
class FinancialEntry {
  final String? documentId;
  final String type;
  final String description;
  final double value;
  final String nature;
  final String recurrence;
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

class FinancialManager extends StatefulWidget {
  const FinancialManager({super.key});

  @override
  State<FinancialManager> createState() => _FinancialManagerState();
}

class _FinancialManagerState extends State<FinancialManager> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _typeController = TextEditingController(
    text: 'Selecione...',
  );
  final TextEditingController _natureController = TextEditingController(
    text: 'Selecione...',
  );
  final TextEditingController _recurrenceController = TextEditingController(
    text: 'Único',
  );
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void dispose() {
    for (var controller in [
      _descriptionController,
      _valueController,
      _typeController,
      _natureController,
      _recurrenceController,
      _dueDateController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- LÓGICA DE PERSISTÊNCIA (Firebase) ---

  Future<void> _saveEntry() async {
    final description = _descriptionController.text.trim();
    final valueText = _valueController.text.replaceAll(',', '.');
    final value = double.tryParse(valueText);

    if (description.isEmpty || value == null || value <= 0) {
      _showSnackBar(
        'Preencha os campos obrigatórios corretamente.',
        Colors.orange,
      );
      return;
    }

    final entry = FinancialEntry(
      type: _typeController.text,
      description: description,
      value: value,
      nature: _natureController.text,
      recurrence: _recurrenceController.text,
      dueDate: _dueDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_dueDateController.text)
          : null,
    );

    final success = await _sendToFirestore(entry);
    if (success && mounted) {
      _showSnackBar('Lançamento salvo com sucesso!', Colors.green);
      Navigator.pop(context);
    }
  }

  Future<bool> _sendToFirestore(FinancialEntry entry) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final data = entry.toMap();
      data['userId'] = user.uid;
      data['createdAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('financial_entries')
          .add(data);
      return true;
    } catch (e) {
      _showSnackBar('Erro: ${e.toString()}', Colors.red);
      return false;
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(
        () => _dueDateController.text = DateFormat('dd/MM/yyyy').format(picked),
      );
    }
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      title: "Adicionar Lançamento",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDropdown([
                    'Selecione...',
                    'Ativo',
                    'Passivo',
                  ], _typeController),
                ),

                Expanded(
                  child: _buildDropdown([
                    'Selecione...',
                    'Receita',
                    'Despesa',
                    'Jogos',
                    'Academia',
                  ], _natureController),
                ),
              ],
            ),

            // Uso do widget refatorado InputForm
            InputForm(
              placeholder: 'Descrição do lançamento',
              controller: _descriptionController,
            ),

            Row(
              children: [
                Expanded(
                  child: InputForm(
                    placeholder: 'Valor (0.00)',
                    controller: _valueController,
                  ),
                ),
                Expanded(
                  child: _buildDropdown([
                    'Único',
                    'Diário',
                    'Mensal',
                    'Semanal',
                    'Quinzenal',
                    'Bimestral',
                    'Trimestral',
                    'Semestral',
                    'Anual',
                    'Personalizado',
                  ], _recurrenceController),
                ),
              ],
            ),

            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                // Impede o teclado de abrir no campo de data
                child: InputForm(
                  placeholder: 'Data de Vencimento',
                  controller: _dueDateController,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SALVAR LANÇAMENTO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, TextEditingController controller) {
    return DropdownList(
      values: items,
      initialValue: controller.text,
      onChanged: (val) => setState(() => controller.text = val!),
    );
  }
}

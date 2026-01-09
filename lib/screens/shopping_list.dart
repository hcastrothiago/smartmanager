import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/input_form.dart';
import 'package:smartmanager/widgets/dropdown_list.dart';
import 'package:smartmanager/widgets/button.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final _dietaController = TextEditingController();
  final _prazoController = TextEditingController();
  String? _tipoDieta;
  bool _loading = false;

  @override
  void dispose() {
    _dietaController.dispose();
    _prazoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(
        () => _prazoController.text = DateFormat('dd/MM/yyyy').format(picked),
      );
    }
  }

  Future<void> _saveShoppingList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _tipoDieta == null || _dietaController.text.isEmpty)
      return;

    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance.collection('shopping_lists').add({
        'userId': user.uid,
        'tipoDieta': _tipoDieta,
        'dieta': _dietaController.text,
        'prazo': _prazoController.text.isNotEmpty
            ? DateFormat(
                'dd/MM/yyyy',
              ).parse(_prazoController.text).toIso8601String()
            : null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Erro ao salvar: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      title: "Nova Dieta",
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Dropdown padronizado
            DropdownList(
              hint: "Selecione o tipo de dieta",
              values: const [
                "Hipertrofia",
                "Perda de Peso",
                "Diminuir Açúcar",
                "Vegana",
              ],
              initialValue: _tipoDieta,
              onChanged: (val) => setState(() => _tipoDieta = val),
            ),

            // Calendário
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: InputForm(
                  placeholder: "Prazo final da dieta",
                  controller: _prazoController,
                ),
              ),
            ),

            // Text Area de no mínimo 6 linhas
            // Nota: Para 6 linhas, você pode ajustar o TextFormField interno do seu InputForm se necessário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                controller: _dietaController,
                maxLines: 6,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Descreva sua dieta aqui...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Botão Salvar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Button(label: "SALVAR DIETA", onPressed: _saveShoppingList),
            ),
          ],
        ),
      ),
    );
  }
}

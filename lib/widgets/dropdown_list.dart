import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  final List<String> values;
  final String? initialValue;
  final String? hint; // Novo campo para o texto de instrução
  final void Function(String?)? onChanged;

  const DropdownList({
    super.key,
    required this.values,
    this.initialValue,
    this.hint, // Adicionado ao construtor
    this.onChanged,
  });

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selected,
        hint: Text(
          widget.hint ?? "Selecione",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        iconEnabledColor: Colors.black,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        items: widget.values.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (val) {
          setState(() => selected = val);
          widget.onChanged?.call(val);
        },
      ),
    );
  }
}

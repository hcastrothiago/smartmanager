// dropdown_list.dart
import 'dart:collection';
import 'package:flutter/material.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

class DropdownList extends StatefulWidget {
  // ... (propriedades inalteradas)
  final List<String> values;
  final String? initialValue;
  final void Function(String?)? onChanged;

  const DropdownList({
    super.key,
    required this.values,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue ?? widget.values.first;
  }

  @override
  Widget build(BuildContext context) {
    final menuEntries = UnmodifiableListView<MenuEntry>(
      widget.values.map((v) => MenuEntry(value: v, label: v)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: DropdownMenu<String>(
        width: MediaQuery.of(context).size.width - (16 * 2),
        initialSelection: selected,
        dropdownMenuEntries: menuEntries,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
        ),
        onSelected: (value) {
          if (value == null) return;
          setState(() => selected = value);
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}

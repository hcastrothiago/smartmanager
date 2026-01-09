import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;

  const InputForm({super.key, required this.placeholder, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey.shade600),

          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),

          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),

          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),

          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}

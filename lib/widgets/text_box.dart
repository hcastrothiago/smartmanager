import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;

  const TextBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
        softWrap: true,
      ),
    );
  }
}

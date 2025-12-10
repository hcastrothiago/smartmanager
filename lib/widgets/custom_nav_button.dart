import 'package:flutter/material.dart';

class CustomNavButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomNavButton({
    super.key,
    required this.label,
    required this.textColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor, width: 1),
        ),
        minimumSize: Size.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
      ),
    );
  }
}

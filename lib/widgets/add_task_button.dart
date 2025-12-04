import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddTaskButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.black),
    );
  }
}

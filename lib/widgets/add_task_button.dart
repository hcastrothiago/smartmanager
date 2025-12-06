import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddTaskButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: onPressed ?? () {},
      child: const Icon(Icons.add, color: Colors.black),
    );
  }
}

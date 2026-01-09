import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onMenuTap;

  const TaskCard({super.key, required this.task, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CONTEÚDO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Data: ${_formatDate(task.date)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duração: ${task.duration}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Calorias estimadas: ${task.calories} kcal',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // MENU (⋮)
            IconButton(icon: const Icon(Icons.more_vert), onPressed: onMenuTap),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Exemplo simples, pode evoluir depois
    return 'Hoje às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class Task {
  final String id;
  final String title;
  final DateTime date;
  final String duration;
  final int calories;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    required this.calories,
  });
}

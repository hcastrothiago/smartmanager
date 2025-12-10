import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/add_task_button.dart';

class GymWorkoutsEmpty extends StatelessWidget {
  const GymWorkoutsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      title: 'Minhas Tarefas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 90),

          // Ícone + texto central
          const Center(
            child: Column(
              children: [
                Icon(
                  Icons.access_alarms_rounded,
                  size: 110,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  "Você não possui nenhuma tarefa.",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ],
            ),
          ),

          // Garantir que o botão fique na parte inferior
          const Spacer(),

          // Botão de adicionar tarefa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: AddTaskButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/gym_workouts');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/menu_sanduwitch.dart';
import '../widgets/add_task_button.dart';

class GymWorkouts extends StatelessWidget {
  const GymWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SandwichMenu(),

      appBar: AppBar(
        title: const Text(
          "Tarefas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.withOpacity(0.7),
        elevation: 0,
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB388FF), // topo roxo
              Color(0xFFCE93D8), // meio lilás
              Color(0xFFFFFFFF), // branco
            ],
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Minhas tarefas
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Minhas tarefas",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 70),

            // Ícone + texto central
            Center(
              child: Column(
                children: const [
                  Icon(
                    Icons.access_alarms_rounded,
                    size: 110,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Você não possui nenhuma tarefa.",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: AddTaskButton(
        onPressed: () {
          // ação ao clicar no +
          print("Adicionar tarefa clicado");
        },
      ),
    );
  }
}

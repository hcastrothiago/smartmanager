import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/add_task_button.dart';
import 'package:smartmanager/widgets/task_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GymWorkoutsEmpty extends StatelessWidget {
  const GymWorkoutsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return DefaultScreen(
      title: 'Minhas Tarefas',
      child: StreamBuilder<QuerySnapshot>(
        stream: currentUser != null
            ? FirebaseFirestore.instance
                  .collection('gym_workouts')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots()
            : null,
        builder: (context, snapshot) {
          // Verificar se está carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // Verificar se há erro
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar tarefas: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          // Verificar se não há dados ou se não há tarefas
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              currentUser == null) {
            // Tela vazia - manter o comportamento original
            return Column(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
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
            );
          }

          // Há tarefas - renderizar lista
          final tasks = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Converter createdAt de Timestamp para DateTime
            DateTime date;
            if (data['createdAt'] != null) {
              final timestamp = data['createdAt'] as Timestamp;
              date = timestamp.toDate();
            } else {
              date = DateTime.now();
            }

            // Converter calorias de String para int
            int calories;
            try {
              calories = int.tryParse(data['calorias']?.toString() ?? '0') ?? 0;
            } catch (e) {
              calories = 0;
            }

            // Criar título combinando tipo e frequência
            String title = data['tipo']?.toString() ?? 'Atividade';
            if (data['frequencia'] != null) {
              title += ' - ${data['frequencia']}';
            }

            return Task(
              id: doc.id,
              title: title,
              date: date,
              duration: data['duracao']?.toString() ?? 'Não especificado',
              calories: calories,
            );
          }).toList();

          // Ordenar tarefas por data (mais recentes primeiro)
          tasks.sort((a, b) => b.date.compareTo(a.date));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Lista de tarefas
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      task: tasks[index],
                      onMenuTap: () {
                        // Ação do menu (pode ser implementada depois)
                      },
                    );
                  },
                ),
              ),

              // Botão de adicionar tarefa
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
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
          );
        },
      ),
    );
  }
}

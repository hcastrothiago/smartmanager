import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/add_task_button.dart';
import 'package:smartmanager/widgets/information_card.dart';

class GymWorkoutsEmpty extends StatelessWidget {
  const GymWorkoutsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return DefaultScreen(
      title: "Minhas Tarefas",
      child: StreamBuilder<QuerySnapshot>(
        stream: currentUser != null
            ? FirebaseFirestore.instance
                  .collection('gym_workouts')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // LÓGICA DE TELA VAZIA: Imagem despertador.png
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              currentUser == null) {
            return _buildEmptyState(
              context,
              'assets/images/despertador.png',
              "Você não possui treinos registrados.",
            );
          }

          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(top: 20, bottom: 100),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return InformationCard(
                    title: data['exercicio'] ?? 'Treino Sem Nome',
                    value: '${data['calorias'] ?? 0} kcal',
                    valueColor: Colors.deepOrange,
                    subTitle: data['duracao'] ?? '0 min',
                    badgeLabels: ['Academia', data['intensidade'] ?? 'Média'],
                    badgeColors: const [Colors.green, Colors.red],
                    onDelete: () => FirebaseFirestore.instance
                        .collection('gym_workouts')
                        .doc(doc.id)
                        .delete(),
                  );
                },
              ),
              _buildAddButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String imagePath,
    String message,
  ) {
    return Column(
      children: [
        const SizedBox(height: 90),
        Center(
          child: Column(
            children: [
              Image.asset(imagePath, height: 200, fit: BoxFit.contain),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(fontSize: 17, color: Colors.white),
              ),
            ],
          ),
        ),
        const Spacer(),
        _buildAddButton(context),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.bottomRight,
        child: AddTaskButton(
          onPressed: () => Navigator.pushNamed(context, '/gym_workouts'),
        ),
      ),
    );
  }
}

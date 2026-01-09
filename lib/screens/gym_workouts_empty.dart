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

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildAddButton(context);
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
                    title: data['exercicio'] ?? 'Treino',
                    value: '${data['calorias'] ?? 0} kcal',
                    valueColor: Colors.deepOrange,
                    subTitle: data['duracao'] ?? '',
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

  Widget _buildAddButton(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: AddTaskButton(
        onPressed: () => Navigator.pushNamed(context, '/gym_workouts'),
      ),
    );
  }
}

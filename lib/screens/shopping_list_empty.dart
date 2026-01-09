import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/add_task_button.dart';
import 'package:smartmanager/widgets/information_card.dart';

class ShoppingListEmpty extends StatelessWidget {
  const ShoppingListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return DefaultScreen(
      child: StreamBuilder<QuerySnapshot>(
        stream: currentUser != null
            ? FirebaseFirestore.instance
                  .collection('shopping_lists')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // Lógica de Tela Vazia com imagem carrinho_vazio.png
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              currentUser == null) {
            return _buildEmptyState(context);
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
                    title: data['tipoDieta'] ?? 'Minha Dieta',
                    value: 'Ver Detalhes', // Texto fixo para o valor
                    valueColor: Colors.blueAccent,
                    subTitle: data['prazo'] != null
                        ? 'Até: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['prazo']))}'
                        : '',
                    badgeLabels: const ['Dieta'],
                    badgeColors: const [Colors.green],
                    onDelete: () => FirebaseFirestore.instance
                        .collection('shopping_lists')
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

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 90),
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/carrinho_vazio.png',
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Sua lista de compras está vazia.",
                style: TextStyle(fontSize: 17, color: Colors.white),
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
          onPressed: () => Navigator.pushNamed(context, '/shopping_list'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/add_task_button.dart';
import 'package:smartmanager/widgets/information_card.dart'; // O widget com o botão embutido
import 'package:smartmanager/screens/financial_manager.dart';

class FinancialManagerEmpty extends StatelessWidget {
  const FinancialManagerEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return DefaultScreen(
      title: "Gerenciador Financeiro",
      child: StreamBuilder<QuerySnapshot>(
        stream: currentUser != null
            ? FirebaseFirestore.instance
                  .collection('financial_entries')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // VISÃO INICIAL (TELA VAZIA) - Sua visão original
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              currentUser == null) {
            return _buildEmptyLayout(context);
          }

          // VISÃO COM REGISTROS
          final entries = snapshot.data!.docs
              .map((doc) => FinancialEntry.fromFirestore(doc))
              .toList();
          entries.sort(
            (a, b) => (a.dueDate ?? DateTime.now()).compareTo(
              b.dueDate ?? DateTime.now(),
            ),
          );

          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(top: 20, bottom: 100),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return InformationCard(
                    title: entry.description,
                    value: 'R\$ ${entry.value.toStringAsFixed(2)}',
                    valueColor: entry.nature == 'Receita'
                        ? Colors.green
                        : Colors.red,
                    subTitle: entry.dueDate != null
                        ? DateFormat('dd/MM/yyyy').format(entry.dueDate!)
                        : null,
                    badgeLabels: [entry.type, entry.nature, entry.recurrence],
                    badgeColors: const [
                      Colors.blue,
                      Colors.purple,
                      Colors.green,
                    ],
                    onDelete: () => _deleteEntry(
                      entry.documentId,
                    ), // Chama a função de remoção
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

  void _deleteEntry(String? id) {
    if (id != null) {
      FirebaseFirestore.instance
          .collection('financial_entries')
          .doc(id)
          .delete();
    }
  }

  Widget _buildEmptyLayout(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 90),
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/empty_financial.png',
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Você não possui nenhuma transação.",
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
          onPressed: () => Navigator.pushNamed(context, '/financial_manager'),
        ),
      ),
    );
  }
}

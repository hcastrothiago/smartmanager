import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/add_task_button.dart';
import 'package:smartmanager/widgets/information_card.dart';
import 'package:smartmanager/screens/financial_manager.dart';

class FinancialManagerEmpty extends StatelessWidget {
  const FinancialManagerEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return DefaultScreen(
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

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return _buildEmptyState(context);
          }

          final entries = snapshot.data!.docs
              .map((doc) => FinancialEntry.fromFirestore(doc))
              .toList();

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
                      Colors.orange,
                    ],
                    onDelete: () => _deleteEntry(entry.documentId),
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

  Widget _buildEmptyState(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text(
            "Nenhum registro encontrado.",
            style: TextStyle(color: Colors.white),
          ),
        ),
        _buildAddButton(context),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: AddTaskButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FinancialManager()),
        ),
      ),
    );
  }
}

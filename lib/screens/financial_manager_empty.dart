import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/add_task_button.dart';
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

          // Ordenação descendente por data
          entries.sort(
            (a, b) => (b.dueDate ?? DateTime.now()).compareTo(
              a.dueDate ?? DateTime.now(),
            ),
          );

          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(top: 20, bottom: 100),
                itemCount: entries.length,
                itemBuilder: (context, index) =>
                    _FinancialEntryCard(entry: entries[index]),
              ),
              _buildAddButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/empty_financial.png', height: 200),
              const SizedBox(height: 20),
              const Text(
                "Nenhuma transação encontrada.",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ],
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

class _FinancialEntryCard extends StatelessWidget {
  final FinancialEntry entry;
  const _FinancialEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isIncome = entry.nature == 'Receita';

    return Dismissible(
      key: Key(entry.documentId ?? ''),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      onDismissed: (_) => FirebaseFirestore.instance
          .collection('financial_entries')
          .doc(entry.documentId)
          .delete(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8.0,
        ), // Padding do Card original
        child: Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16), // Padding interno restaurado
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.description,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildBadges(), // Badges restauradas
                    ],
                  ),
                ),
                _buildValueSection(isIncome),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _ChipBadge(label: entry.type, color: Colors.blue[50]!),
        _ChipBadge(label: entry.nature, color: Colors.purple[50]!),
        _ChipBadge(label: entry.recurrence, color: Colors.green[50]!),
      ],
    );
  }

  Widget _buildValueSection(bool isIncome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'R\$ ${entry.value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20, // Fonte maior restaurada
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (entry.dueDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              DateFormat('dd/MM/yyyy').format(entry.dueDate!),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete_forever, color: Colors.white),
    );
  }
}

class _ChipBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _ChipBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}

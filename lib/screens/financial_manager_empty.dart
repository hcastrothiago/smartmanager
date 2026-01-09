import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/add_task_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/screens/financial_manager.dart';
import 'package:intl/intl.dart';

class FinancialManagerEmpty extends StatelessWidget {
  const FinancialManagerEmpty({super.key});

  Widget _buildEntryCard(BuildContext context, FinancialEntry entry) {
    final isIncome = entry.nature == 'Receita';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            Chip(
                              label: Text(
                                entry.type,
                                style: const TextStyle(fontSize: 11),
                              ),
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.blue[50],
                            ),
                            Chip(
                              label: Text(
                                entry.nature,
                                style: const TextStyle(fontSize: 11),
                              ),
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.purple[50],
                            ),
                            Chip(
                              label: Text(
                                entry.recurrence,
                                style: const TextStyle(fontSize: 11),
                              ),
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.green[50],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${entry.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          color: isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (entry.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(entry.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, String documentId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('financial_entries')
          .doc(documentId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lançamento excluído com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir lançamento: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return DefaultScreen(
      title: 'Gestor Financeiro',
      child: StreamBuilder<QuerySnapshot>(
        stream: currentUser != null
            ? FirebaseFirestore.instance
                  .collection('financial_entries')
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
                'Erro ao carregar lançamentos: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          // Verificar se não há dados ou se não há lançamentos
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              currentUser == null) {
            // Tela vazia - mostrar imagem
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 90),

                // Imagem + texto central
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

                // Garantir que o botão fique na parte inferior
                const Spacer(),

                // Botão de adicionar transação
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: AddTaskButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FinancialManager(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          // Há lançamentos - renderizar lista de cards
          final entries = snapshot.data!.docs
              .map((doc) => FinancialEntry.fromFirestore(doc))
              .toList();

          // Ordenar por dueDate (itens sem data ficam no final)
          entries.sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) return 0;
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Lista de lançamentos
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Dismissible(
                      key: Key(entry.documentId ?? 'entry_$index'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        if (entry.documentId != null) {
                          _deleteEntry(context, entry.documentId!);
                        }
                      },
                      child: _buildEntryCard(context, entry),
                    );
                  },
                ),
              ),

              // Botão de adicionar transação
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: AddTaskButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FinancialManager(),
                        ),
                      );
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

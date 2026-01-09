import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/widgets/carousel.dart';
import 'package:smartmanager/widgets/image_described.dart';
import 'package:smartmanager/widgets/menu_sanduwitch.dart';
import 'package:smartmanager/widgets/text_box.dart';
import 'package:smartmanager/widgets/my_pie_chart.dart';
import 'package:intl/intl.dart';

class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const Color headerColor = Color.fromARGB(255, 81, 28, 150);
    final Color onHeaderColor = theme.colorScheme.onPrimary;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color.fromARGB(255, 134, 82, 201), Color(0xFFFFFCFF)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Dashboard Principal'),
          backgroundColor:
              theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: theme.appBarTheme.foregroundColor ?? Colors.white,
          elevation: 4,
        ),
        drawer: SandwichMenu(),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            // CABEÇALHO
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/user_profile.png'),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        _UserInfo(onHeaderColor: onHeaderColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // GRID DE OPÇÕES
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double itemWidth = (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: const ImageDescribed(
                          description: 'Eventos',
                          imagePath: 'assets/images/eventos.png',
                          spacing: 4,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/gym_workouts_empty');
                          },
                          child: const ImageDescribed(
                            description: 'Atividades',
                            imagePath:
                                'assets/images/atividade-removebg-preview.png',
                            spacing: 4,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/financial_manager',
                          ),
                          child: const ImageDescribed(
                            description: 'Finanças',
                            imagePath: 'assets/images/financas.png',
                            spacing: 4,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/shopping_list'),
                          child: const ImageDescribed(
                            description: 'Alimentação',
                            imagePath: 'assets/images/alimentacao.png',
                            spacing: 4,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            _CarouselBuilder(),
          ],
        ),
      ),
    );
  }
}

class _CarouselBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('gym_workouts')
          .where('userId', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, tasksSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('financial_entries')
              .where('userId', isEqualTo: currentUser.uid)
              .snapshots(),
          builder: (context, financialSnapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('shopping_list')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (context, shoppingSnapshot) {
                // Processar tarefas para eventos e atividades
                List<Map<String, dynamic>> tasks = [];
                if (tasksSnapshot.hasData && tasksSnapshot.data != null) {
                  tasks = tasksSnapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    DateTime date = DateTime.now();
                    if (data['createdAt'] != null) {
                      final timestamp = data['createdAt'] as Timestamp;
                      date = timestamp.toDate();
                    }
                    return {
                      'id': doc.id,
                      'tipo': data['tipo']?.toString() ?? 'Atividade',
                      'frequencia': data['frequencia']?.toString() ?? '',
                      'duracao': data['duracao']?.toString() ?? 'Não especificado',
                      'calorias': data['calorias']?.toString() ?? '0',
                      'date': date,
                    };
                  }).toList();
                  
                  // Ordenar por data
                  tasks.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
                }

                // Filtrar eventos futuros (próximos eventos) e passados
                final now = DateTime.now();
                final upcomingTasks = tasks.where((task) {
                  return (task['date'] as DateTime).isAfter(now);
                }).take(2).toList();
                
                final pastTasks = tasks.where((task) {
                  return (task['date'] as DateTime).isBefore(now);
                }).toList();

                // Calcular produtividade para o gráfico
                final totalTasks = tasks.length;
                final completedTasks = pastTasks.length;
                final productivityPercent = totalTasks > 0 
                    ? (completedTasks / totalTasks * 100).round()
                    : 0;

                // Processar lançamentos financeiros
                List<Map<String, dynamic>> financialEntries = [];
                double totalReceitas = 0.0;
                double totalDespesas = 0.0;
                
                if (financialSnapshot.hasData && financialSnapshot.data != null) {
                  financialEntries = financialSnapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'id': doc.id,
                      'description': data['description'] ?? '',
                      'value': (data['value'] ?? 0.0).toDouble(),
                      'nature': data['nature'] ?? 'Despesa',
                      'dueDate': data['dueDate'] != null 
                          ? DateTime.parse(data['dueDate'])
                          : null,
                    };
                  }).toList();

                  // Calcular totais
                  for (var entry in financialEntries) {
                    if (entry['nature'] == 'Receita') {
                      totalReceitas += entry['value'];
                    } else {
                      totalDespesas += entry['value'];
                    }
                  }

                  // Ordenar por data de vencimento (mais próximos primeiro)
                  financialEntries.sort((a, b) {
                    final dateA = a['dueDate'] as DateTime?;
                    final dateB = b['dueDate'] as DateTime?;
                    if (dateA == null && dateB == null) return 0;
                    if (dateA == null) return 1;
                    if (dateB == null) return -1;
                    return dateA.compareTo(dateB);
                  });

                  // Limitar a 3
                  financialEntries = financialEntries.take(3).toList();
                }

                final totalRecursos = totalReceitas - totalDespesas;

                // Processar lista de compras
                List<Map<String, dynamic>> shoppingItems = [];
                if (shoppingSnapshot.hasData && shoppingSnapshot.data != null) {
                  shoppingItems = shoppingSnapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'id': doc.id,
                      'name': data['name'] ?? '',
                      'category': data['category'] ?? 'Outros',
                      'quantity': data['quantity'] ?? 1,
                    };
                  }).take(2).toList();
                }

                // Processar atividades (pelo menos 2) - pegar as mais recentes
                final activitiesTasks = tasks.length >= 2 
                    ? tasks.take(2).toList()
                    : tasks.toList();

                return AppCarousel(
                  items: [
                    // Primeira aba: Próximos Eventos
                    CarouselCardData(
                      title: 'Próximos Eventos',
                      subTitle: 'Produtividade',
                      text1: upcomingTasks.isNotEmpty
                          ? '${upcomingTasks[0]['tipo']}: ${_formatTime(upcomingTasks[0]['date'])}'
                          : 'Sem eventos',
                      text2: upcomingTasks.length > 1
                          ? '${upcomingTasks[1]['tipo']}: ${_formatTime(upcomingTasks[1]['date'])}'
                          : '',
                      leftIcon: Icons.event_outlined,
                      color: Colors.white,
                      component: MyPieChart(percent: productivityPercent.toDouble()),
                    ),
                    // Segunda aba: Finanças
                    CarouselCardData(
                      title: 'Finanças',
                      subTitle: 'Recursos',
                      text1: financialEntries.isNotEmpty
                          ? '${financialEntries[0]['description']}'
                          : 'Sem lançamentos',
                      text2: financialEntries.length > 1
                          ? (financialEntries.length > 2 
                              ? '${financialEntries[1]['description']}, ${financialEntries[2]['description']}'
                              : financialEntries[1]['description'])
                          : '',
                      leftIcon: Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                      component: TextBox(
                        text: 'R\$ ${totalRecursos.toStringAsFixed(2)}',
                      ),
                    ),
                    // Terceira aba: Alimentação
                    CarouselCardData(
                      title: 'Alimentação',
                      subTitle: 'Metas',
                      text1: shoppingItems.isNotEmpty
                          ? '${shoppingItems[0]['name']} (${shoppingItems[0]['quantity']})'
                          : 'Sem itens',
                      text2: shoppingItems.length > 1
                          ? '${shoppingItems[1]['name']} (${shoppingItems[1]['quantity']})'
                          : '',
                      leftIcon: Icons.restaurant_menu_outlined,
                      color: Colors.white,
                      component: const TextBox(text: "-Kg"),
                    ),
                    // Última aba: Atividades
                    CarouselCardData(
                      title: 'Atividades',
                      subTitle: activitiesTasks.isNotEmpty
                          ? activitiesTasks[0]['duracao']
                          : '',
                      text1: activitiesTasks.isNotEmpty
                          ? '${activitiesTasks[0]['tipo']}: ${_formatDate(activitiesTasks[0]['date'])}'
                          : 'Sem atividades',
                      text2: activitiesTasks.length > 1
                          ? '${activitiesTasks[1]['tipo']}: ${activitiesTasks[1]['duracao']}'
                          : '',
                      leftIcon: Icons.fitness_center,
                      color: Colors.white,
                      component: TextBox(
                        text: activitiesTasks.isNotEmpty
                            ? activitiesTasks[0]['duracao']
                            : '',
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }
}

class _UserInfo extends StatelessWidget {
  final Color onHeaderColor;

  const _UserInfo({required this.onHeaderColor});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usuário não autenticado',
            style: TextStyle(
              color: onHeaderColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    // Busca os dados do usuário no Firestore
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        // Enquanto carrega, mostra o email do Auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Carregando...',
                style: TextStyle(
                  color: onHeaderColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                currentUser.email ?? '',
                style: TextStyle(color: onHeaderColor, fontSize: 13),
              ),
            ],
          );
        }

        // Se houver erro ou dados não encontrados, usa dados do Auth
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          String displayName =
              currentUser.displayName ??
              currentUser.email?.split('@')[0] ??
              'Usuário';

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: TextStyle(
                  color: onHeaderColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                currentUser.email ?? '',
                style: TextStyle(color: onHeaderColor, fontSize: 13),
              ),
            ],
          );
        }

        // Dados do Firestore disponíveis
        final userData = snapshot.data!.data() as Map<String, dynamic>?;

        // Monta o nome completo: firstName + lastName ou username
        String displayName;
        if (userData != null) {
          if (userData['firstName'] != null && userData['lastName'] != null) {
            displayName = '${userData['firstName']} ${userData['lastName']}';
          } else if (userData['username'] != null) {
            displayName = userData['username'] as String;
          } else {
            displayName = currentUser.email?.split('@')[0] ?? 'Usuário';
          }
        } else {
          displayName = currentUser.email?.split('@')[0] ?? 'Usuário';
        }

        // Email do Firestore ou do Auth
        final email = userData?['email'] as String? ?? currentUser.email ?? '';

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName,
              style: TextStyle(
                color: onHeaderColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(email, style: TextStyle(color: onHeaderColor, fontSize: 13)),
          ],
        );
      },
    );
  }
}

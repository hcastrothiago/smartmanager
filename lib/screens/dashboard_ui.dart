import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartmanager/widgets/carousel.dart';
import 'package:smartmanager/widgets/image_described.dart';
import 'package:smartmanager/widgets/menu_sanduwitch.dart';
import 'package:smartmanager/widgets/text_box.dart';
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

    if (currentUser == null) return const SizedBox.shrink();

    // Sincronização em tempo real com as 3 coleções principais
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
                  .collection(
                    'shopping_lists',
                  ) // Nome corrigido conforme seu banco
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (context, shoppingSnapshot) {
                // --- PROCESSAMENTO DE FINANÇAS ---
                double totalReceitas = 0.0;
                double totalDespesas = 0.0;
                List<String> lastFinDescriptions = [];

                if (financialSnapshot.hasData) {
                  final finDocs = financialSnapshot.data!.docs;
                  for (var doc in finDocs) {
                    final d = doc.data() as Map<String, dynamic>;
                    double val = (d['value'] ?? 0.0).toDouble();
                    if (d['nature'] == 'Receita') {
                      totalReceitas += val;
                    } else {
                      totalDespesas += val;
                    }
                  }
                  // Pegar descrições dos 2 últimos lançamentos
                  lastFinDescriptions = finDocs
                      .take(2)
                      .map(
                        (e) =>
                            (e.data() as Map<String, dynamic>)['description']
                                ?.toString() ??
                            '',
                      )
                      .toList();
                }
                final saldo = totalReceitas - totalDespesas;

                // --- PROCESSAMENTO DE ATIVIDADES ---
                List<Map<String, dynamic>> lastWorkouts = [];
                if (tasksSnapshot.hasData) {
                  lastWorkouts = tasksSnapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                  // Ordenação básica (simulada por ordem de chegada do stream ou campo date se houver)
                }

                // --- PROCESSAMENTO DE ALIMENTAÇÃO ---
                List<Map<String, dynamic>> dietEntries = [];
                if (shoppingSnapshot.hasData) {
                  dietEntries = shoppingSnapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                }

                return AppCarousel(
                  items: [
                    // ABA 1: FINANÇAS (FOCO EM SALDO)
                    CarouselCardData(
                      title: 'Resumo Financeiro',
                      subTitle: 'Saldo Total',
                      text1: lastFinDescriptions.isNotEmpty
                          ? 'Último: ${lastFinDescriptions[0]}'
                          : 'Sem lançamentos',
                      text2: lastFinDescriptions.length > 1
                          ? 'Anterior: ${lastFinDescriptions[1]}'
                          : 'Aguardando dados...',
                      leftIcon: Icons.account_balance_wallet_outlined,
                      component: TextBox(
                        text: 'R\$ ${saldo.toStringAsFixed(2)}',
                      ),
                    ),

                    // ABA 2: ATIVIDADES (FOCO EM ÚLTIMO TREINO)
                    CarouselCardData(
                      title: 'Última Atividade',
                      subTitle: lastWorkouts.isNotEmpty
                          ? (lastWorkouts[0]['duracao'] ?? '0 min')
                          : '0 min',
                      text1: lastWorkouts.isNotEmpty
                          ? '${lastWorkouts[0]['tipo'] ?? 'Treino'}'
                          : 'Nenhuma atividade',
                      text2: lastWorkouts.isNotEmpty
                          ? 'Gasto: ${lastWorkouts[0]['calorias'] ?? 0} kcal'
                          : 'Inicie um treino!',
                      leftIcon: Icons.fitness_center,
                      component: TextBox(
                        text: lastWorkouts.isNotEmpty
                            ? '${lastWorkouts[0]['calorias']} kcal'
                            : '-',
                      ),
                    ),

                    // ABA 3: ALIMENTAÇÃO (FOCO EM DIETA ATIVA)
                    CarouselCardData(
                      title: 'Plano Alimentar',
                      subTitle: 'Meta Diária',
                      text1: dietEntries.isNotEmpty
                          ? 'Tipo: ${dietEntries[0]['tipoDieta'] ?? 'Geral'}'
                          : 'Sem dieta ativa',
                      text2: dietEntries.isNotEmpty
                          ? 'Prazo: ${dietEntries[0]['prazo'] != null ? DateFormat('dd/MM').format(DateTime.parse(dietEntries[0]['prazo'])) : 'S/P'}'
                          : 'Configure sua dieta',
                      leftIcon: Icons.restaurant_menu_outlined,
                      component: const TextBox(text: "Em dia"),
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

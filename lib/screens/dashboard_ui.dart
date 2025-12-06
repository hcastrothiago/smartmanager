import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/carousel.dart';
import 'package:smartmanager/widgets/image_described.dart';
import 'package:smartmanager/widgets/menu_sanduwitch.dart';

class DashboardUI extends StatelessWidget {
  const DashboardUI({super.key});

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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Felipe Emanuel',
                              style: TextStyle(
                                color: onHeaderColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'heraclito@thiago.com',
                              style: TextStyle(
                                color: onHeaderColor,
                                fontSize: 13,
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
                        child: const ImageDescribed(
                          description: 'Atividades',
                          imagePath:
                              'assets/images/atividade-removebg-preview.png',
                          spacing: 4,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: const ImageDescribed(
                          description: 'Finanças',
                          imagePath: 'assets/images/financas.png',
                          spacing: 4,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: const ImageDescribed(
                          description: 'Alimentação',
                          imagePath: 'assets/images/alimentacao.png',
                          spacing: 4,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            AppCarousel(
              items: [
                _carouselCard(
                  'Próximos Eventos',
                  'Produtividade',
                  Icons.event_busy_outlined,
                ),
                _carouselCard(
                  'Finanças',
                  'Recursos',
                  Icons.account_balance_wallet_outlined,
                ),
                _carouselCard(
                  'Alimentação',
                  'Metas',
                  Icons.restaurant_menu_outlined,
                ),
                _carouselCard('Atividades', '', Icons.people),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _carouselCard(
  String title,
  String subTitle,
  IconData icon, {
  Color color = Colors.white,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: color.withOpacity(0.85),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            icon,
                            color: const Color.fromARGB(255, 130, 80, 195),
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Texto 1 grande'),
                              Text('Texto 2 pequeno'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 130, 80, 195),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

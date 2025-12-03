import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessando as cores do Moon Design para consistência
    final MoonColors colors = MoonColors.light;

    return Scaffold(
      // 1. AppBar sem título, permitindo que o ícone de menu (hambúrguer) apareça
      // automaticamente devido à propriedade 'drawer'.
      appBar: AppBar(
        // Removendo o título da AppBar
        title: null,
        elevation: 0,
        backgroundColor: Theme.of(
          context,
        ).scaffoldBackgroundColor, // Fundo transparente na AppBar
      ),

      // 2. O Drawer (menu sanduíche) com as rotas de navegação
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Cabeçalho do Menu
            DrawerHeader(
              decoration: BoxDecoration(
                color: colors.piccolo, // Cor primária do Moon Design
              ),
              child: Text(
                'Navegação',
                style: TextStyle(
                  color: colors.goku,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Item 1: Ir para Página 1
            ListTile(
              leading: Icon(Icons.dashboard_outlined, color: colors.hit),
              title: const Text('Página 1'),
              onTap: () {
                // Fecha o drawer antes de navegar e mantém a pilha de navegação limpa
                Navigator.pop(context);
                Navigator.pushNamed(context, '/shopping_list');
              },
            ),

            // Item 2: Ir para Página 2
            ListTile(
              leading: Icon(Icons.analytics_outlined, color: colors.hit),
              title: const Text('Página 2'),
              onTap: () {
                // Fecha o drawer antes de navegar
                Navigator.pop(context);
                Navigator.pushNamed(context, '/page2');
              },
            ),

            // Item 3: Primeira Execução do App
            ListTile(
              leading: Icon(Icons.run_circle_outlined, color: colors.hit),
              title: const Text('Primeira Execução do App'),
              onTap: () {
                // Fecha o drawer antes de navegar
                Navigator.pop(context);
                Navigator.pushNamed(context, '/first_run');
              },
            ),
          ],
        ),
      ),

      // 3. O Body com o texto centralizado e estilizado
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'DASHBOARD A SER IMPLEMENTADO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: colors.trunks, // Cor de texto cinza para contraste
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

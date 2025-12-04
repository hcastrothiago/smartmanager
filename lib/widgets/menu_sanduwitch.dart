import 'package:flutter/material.dart';

class SandwichMenu extends StatelessWidget {
  const SandwichMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa as cores e o tema padrão do Material Design
    final ThemeData theme = Theme.of(context);

    // Cor de fundo do cabeçalho (geralmente a cor primária do tema)
    final Color headerColor = theme.colorScheme.primary;
    // Cor do texto/ícone no cabeçalho (contraste com a cor primária)
    final Color onHeaderColor = theme.colorScheme.onPrimary;
    // Cor dos ícones e texto dos itens (contraste com a cor de fundo do Drawer)
    final Color itemIconColor = theme.colorScheme.onSurface;

    return Drawer(
      child: ListView(
        // Remove o padding superior para que o DrawerHeader ocupe toda a área
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Cabeçalho do Menu
          DrawerHeader(
            decoration: BoxDecoration(color: headerColor),
            child: Text(
              'Navegação',
              style: TextStyle(
                color: onHeaderColor, // Usando a cor de contraste
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Item 0: Ir para Página 1 (Shopping List)
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: itemIconColor, // Cor padrão do tema
            ),
            title: const Text('Home'),
            onTap: () {
              // Prático e direto: fecha o drawer e navega.
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
              debugPrint('Navegando para Home');
            },
          ),

          // Item 1: Ir para Página 1 (Shopping List)
          ListTile(
            leading: Icon(
              Icons.shopping_cart_outlined,
              color: itemIconColor, // Cor padrão do tema
            ),
            title: const Text('Lista de Compras'),
            onTap: () {
              // Prático e direto: fecha o drawer e navega.
              Navigator.pop(context);
              Navigator.pushNamed(context, '/shopping_list');
              debugPrint('Navegando para Lista de Compras');
            },
          ),

          // Item 2: Ir para Página 2
          ListTile(
            leading: Icon(
              Icons.sports_gymnastics_outlined,
              color: itemIconColor,
            ),
            title: const Text('Treinos diários'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/gym_workouts');
            },
          ),

          // Tela Felipe Santos
          ListTile(
            leading: Icon(Icons.account_balance_outlined, color: itemIconColor),
            title: const Text('Gestor Financeiro'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/financial_manager');
            },
          ),

          const Divider(),

          // Item para Ação
          ListTile(
            leading: Icon(Icons.help_outline, color: itemIconColor),
            title: const Text('Ajuda'),
            onTap: () {
              Navigator.pop(context);
              // Lógica de ajuda ou FAQ aqui.
              // Seja inovador e use o widget para algo mais do que navegação!
              debugPrint('Ajuda solicitada. Implementar módulo de suporte.');
            },
          ),
        ],
      ),
    );
  }
}

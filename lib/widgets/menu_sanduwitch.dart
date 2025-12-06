import 'package:flutter/material.dart';

class SandwichMenu extends StatelessWidget {
  const SandwichMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color headerColor = theme.colorScheme.primary;
    final Color onHeaderColor = theme.colorScheme.onPrimary;
    final Color itemIconColor = theme.colorScheme.onSurface;

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: headerColor),
            child: Row(
              children: [
                Image(
                  image: const AssetImage('assets/images/user_profile.png'),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
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
                      style: TextStyle(color: onHeaderColor, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person_outline, color: itemIconColor),
                  title: const Text('Cadastrar'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cadastrar');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home_outlined, color: itemIconColor),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart_outlined,
                    color: itemIconColor,
                  ),
                  title: const Text('Lista de Compras'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/shopping_list');
                  },
                ),
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
                ListTile(
                  leading: Icon(
                    Icons.account_balance_outlined,
                    color: itemIconColor,
                  ),
                  title: const Text('Gestor Financeiro'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/financial_manager');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.help_outline, color: itemIconColor),
                  title: const Text('Ajuda'),
                  onTap: () {
                    Navigator.pop(context);
                    debugPrint(
                      'Ajuda solicitada. Implementar módulo de suporte.',
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: Colors.red.shade700,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.red.shade100, width: 1),
                  ),
                  minimumSize: Size.zero,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

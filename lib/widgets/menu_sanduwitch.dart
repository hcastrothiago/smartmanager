import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                _UserInfoDrawer(onHeaderColor: onHeaderColor),
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
                  title: const Text('Tarefas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/gym_workouts_empty');
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
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
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

class _UserInfoDrawer extends StatelessWidget {
  final Color onHeaderColor;

  const _UserInfoDrawer({required this.onHeaderColor});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Expanded(
        child: Column(
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
            Text('', style: TextStyle(color: onHeaderColor, fontSize: 11)),
          ],
        ),
      );
    }

    // Busca os dados do usuário no Firestore
    return Expanded(
      child: StreamBuilder<DocumentSnapshot>(
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
                  style: TextStyle(color: onHeaderColor, fontSize: 11),
                ),
              ],
            );
          }

          // Se houver erro ou dados não encontrados, usa dados do Auth
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
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
                  style: TextStyle(color: onHeaderColor, fontSize: 11),
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
          final email =
              userData?['email'] as String? ?? currentUser.email ?? '';

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
              Text(email, style: TextStyle(color: onHeaderColor, fontSize: 11)),
            ],
          );
        },
      ),
    );
  }
}

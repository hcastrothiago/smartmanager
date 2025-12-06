import 'package:flutter/material.dart';
import 'package:smartmanager/screens/cadastrar.dart';
import 'package:smartmanager/screens/dashboard_ui.dart';
import 'package:smartmanager/screens/default_screen.dart';
import 'screens/financial_manager.dart';
import 'screens/shopping_list.dart';
import 'screens/login.dart';
import 'screens/first_run_app.dart';
import 'screens/gym_workouts.dart';
import 'screens/cadastrofinalizado.dart' hide GymWorkouts;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: const FirstRunApp(),
      routes: {
        '/login': (_) => LoginScreen(),
        '/home': (_) => DashboardUI(),
        '/cadastrar': (_) => CadastroScreen(),
        '/shopping_list': (_) => ShoppingListScreen(),
        '/financial_manager': (_) => FinancialManager(),
        '/gym_workouts': (_) => GymWorkouts(),
        //'/cadastrofinalizado': (_) => EndForm(),
        '/tela_padrao': (_) => DefaultScreen(),
        '/first_run_app': (_) => FirstRunApp(),
        '/dashboard_ui': (_) => const DashboardUI(),
      },
    );
  }
}

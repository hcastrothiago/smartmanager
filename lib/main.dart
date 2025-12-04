import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:smartmanager/screens/default_screen.dart';
import 'screens/home.dart';
import 'screens/financial_manager.dart';
import 'screens/shopping_list.dart';
import 'screens/gym_workouts.dart';
import 'screens/login.dart';
import 'screens/first_run_app.dart';
import 'screens/cadastrar.dart';
import 'screens/cadastrofinalizado.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      debugShowCheckedModeBanner: false,
      home: Login(), // <<< COLOQUE SUA TELA AQUI
=======
      debugShowCheckedModeBanner: true,
      home: DefaultScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
        '/home': (_) => Home(),
        '/shopping_list': (_) => ShoppingListScreen(),
        '/financial_manager': (_) => FinancialManager(),
        '/gym_workouts': (_) => GymWorkouts(),
        '/cadastrofinalizado': (_) => EndForm(),
        '/tela_padrao': (_) => DefaultScreen(),
      },
>>>>>>> 57b8722 (rota shopping_list criada, dashboard alterada, ordem do fluxo de rotas alterada)
    );
  }
}

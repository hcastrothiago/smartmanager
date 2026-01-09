import 'package:flutter/material.dart';
import 'package:smartmanager/screens/cadastrar.dart';
import 'package:smartmanager/screens/dashboard_ui.dart';
import 'package:smartmanager/screens/default_screen.dart';
import 'screens/financial_manager.dart';
import 'screens/shopping_list.dart';
import 'screens/login.dart';
import 'screens/first_run_app.dart';
import 'screens/gym_workouts.dart';
import 'screens/gym_workouts_empty.dart';
// configuração do firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const DashboardUI(),
        '/cadastrar': (context) => const CadastroScreen(),
        '/shopping_list': (context) => const ShoppingListScreen(),
        '/financial_manager': (context) => const FinancialManager(),
        '/gym_workouts': (context) => const GymWorkouts(),
        '/gym_workouts_empty': (_) => GymWorkoutsEmpty(),
        '/tela_padrao': (_) => DefaultScreen(),
        '/first_run_app': (_) => FirstRunApp(),
        '/dashboard_ui': (_) => DashboardUI(),
        //'/cadastrofinalizado': (_) => EndForm(),
      },
    );
  }
}

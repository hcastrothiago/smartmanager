import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:smartmanager/screens/home.dart';
import 'package:smartmanager/screens/shopping_list.dart';
import 'screens/first_run_app.dart';
=======
import 'screens/home.dart';
import 'screens/financial_manager.dart';
import 'screens/shopping_list.dart';
import 'screens/gym_workouts.dart';
>>>>>>> 8688a55dfb7d183ae571f15bae7f4ef2d60364b1
import 'screens/login.dart';
import 'screens/first_run_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: FirstRunApp(),
      routes: {
        '/login': (_) => Login(),
        '/home': (_) => Home(),
        '/shopping_list': (_) => ShoppingListScreen(),
        '/financial_manager': (_) => FinancialManager(),
        '/gym_workouts': (_) => GymWorkouts(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smartmanager/screens/financial_manager.dart';
import 'package:smartmanager/screens/gym_workouts.dart';
import 'package:smartmanager/screens/home.dart';
import 'package:smartmanager/screens/shopping_list.dart';
import 'screens/first_run_app.dart';
import 'screens/login.dart';

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

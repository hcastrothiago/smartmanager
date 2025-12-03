import 'package:flutter/material.dart';
import 'package:smartmanager/screens/home.dart';
import 'package:smartmanager/screens/shopping_list.dart';
import 'screens/login.dart';
import 'package:smartmanager/screens/page2.dart';
import 'package:smartmanager/screens/first_run_app.dart';

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
      home: FirstRunApp(),
      routes: {
        '/login': (_) => Login(),
        '/home': (_) => Home(),
        '/shopping_list': (_) => ShoppingListScreen(),
        '/page2': (_) => PageTwo(),
        '/first_run': (_) => FirstRunApp(),
      },
>>>>>>> 57b8722 (rota shopping_list criada, dashboard alterada, ordem do fluxo de rotas alterada)
    );
  }
}

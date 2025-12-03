import 'package:flutter/material.dart';
import 'package:smartmanager/screens/page1.dart';
import 'package:smartmanager/screens/page2.dart';
import 'package:smartmanager/screens/home.dart';
import 'package:smartmanager/screens/first_run_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartManager',
      theme: ThemeData(brightness: Brightness.light),
      home: const FirstRunApp(),
      routes: {
        '/page1': (_) => const PageOne(),
        '/page2': (_) => const PageTwo(),
        '/home': (_) => const Home(),
      },
    );
  }
}

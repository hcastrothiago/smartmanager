import 'package:flutter/material.dart';
import '../widgets/menu_sanduwitch.dart';

class GymWorkouts extends StatelessWidget {
  const GymWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // <<< NOVO

    return Scaffold(
      appBar: AppBar(
        title: null,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      drawer: const SandwichMenu(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'modificando....',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: const Color.fromARGB(255, 112, 24, 24),
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

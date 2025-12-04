import 'package:flutter/material.dart';
import '../widgets/menu_sanduwitch.dart';

class FinancialManager extends StatelessWidget {
  const FinancialManager({super.key});

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
            'FINANCEIRO A SER IMPLEMENTADO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.grey[500],
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

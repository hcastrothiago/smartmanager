import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/menu_sanduwitch.dart';

class FoodScreen extends StatelessWidget {
  final Widget? child;

  const FoodScreen({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, -0.00),
          end: Alignment(0.50, 1.00),

          colors: [Color(0xFF8250C3), Color(0xFFFFFCFF)],
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Nome da tela'),
          backgroundColor:
          Theme.of(context).appBarTheme.backgroundColor ??
              Theme.of(context).colorScheme.primary,
          foregroundColor:
          Theme.of(context).appBarTheme.foregroundColor ?? Colors.white,
          elevation: 4,
        ),
        drawer: const SandwichMenu(),

        body:
        child ??
            const Center(
              child: Text(
                'TELA PADRÃO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white70,
                  letterSpacing: 1.5,
                ),
              ),
            ),
      ),
    );
  }
}

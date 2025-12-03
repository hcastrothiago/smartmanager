import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MoonTextArea(height: 100),
            MoonFilledButton(
              label: const Text('Ir para Página 1'),
              onTap: () => Navigator.pushNamed(context, '/page1'),
            ),
            const SizedBox(height: 16),
            MoonFilledButton(
              label: const Text('Ir para Página 2'),
              onTap: () => Navigator.pushNamed(context, '/page2'),
            ),
            const SizedBox(height: 16),
            MoonFilledButton(
              label: const Text('Primeira Execução do App'),
              onTap: () => Navigator.pushNamed(context, '/FirstRunApp'),
            ),
          ],
        ),
      ),
    );
  }
}

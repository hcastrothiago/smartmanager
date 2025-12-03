import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página 1')),
      body: SafeArea(
        child: MoonOutlinedButton(
          label: const Text('Voltar'),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

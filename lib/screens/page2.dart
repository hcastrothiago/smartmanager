import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página 2')),
      body: Center(
        child: MoonOutlinedButton(
          label: const Text('Voltar'),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

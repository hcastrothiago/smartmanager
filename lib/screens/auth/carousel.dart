import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagina 2')),
      body: Center(
        child: MoonOutlinedButton(
          label: const Text('Voltar'),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

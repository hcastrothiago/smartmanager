import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/default_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      title: 'Ajuda',
      child: Center(
        child: Text(
          'Envie um email para o LF que ele dá um jeito',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

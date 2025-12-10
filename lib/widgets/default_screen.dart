import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/menu_sanduwitch.dart';

class DefaultScreen extends StatelessWidget {
  final Widget? child;
  final String title;

  const DefaultScreen({super.key, this.child, this.title = "SmartManager"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const SandwichMenu(),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8250C3), Color(0xFFFFFCFF)],
          ),
        ),
        child: SafeArea(
          child: child ?? const Center(child: Text("Conteúdo padrão da tela")),
        ),
      ),
    );
  }
}

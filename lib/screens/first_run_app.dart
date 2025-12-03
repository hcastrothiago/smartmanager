import 'package:flutter/material.dart';

class FirstRunApp extends StatefulWidget {
  const FirstRunApp({super.key});

  @override
  State<FirstRunApp> createState() => _FirstRunAppState();
}

class _FirstRunAppState extends State<FirstRunApp> {
  final List<String> background = [
    'assets/images/onboarding1.jpg',
    'assets/images/onboarding2.jpg',
    'assets/images/onboarding3.jpg',
  ];

  int pos = 0;

  void nextPage() {
    if (pos < background.length - 1) {
      setState(() {
        pos = pos + 1;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fundo
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(background[pos]),
            ),
          ),
        ),

        // Conteúdo
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 14,
                        ),
                        backgroundColor: Colors.black.withOpacity(0.6),
                      ),
                      onPressed: nextPage,
                      child: Text(
                        pos < 2 ? 'Próximo' : 'Vamos lá',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class FirstRunApp extends StatefulWidget {
  const FirstRunApp({super.key});

  @override
  State<FirstRunApp> createState() => _FirstRunAppState();
}

class _FirstRunAppState extends State<FirstRunApp> {
  final List<String> background = [
    // Nota: Estes caminhos presumem que você tem as imagens configuradas no pubspec.yaml
    'assets/images/onboarding1.jpg',
    'assets/images/onboarding2.jpg',
    'assets/images/onboarding3.jpg',
  ];

  int pos = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // -----------------------------------------------------------
    // SOLUÇÃO: Pré-carregar todas as imagens do onboarding na memória.
    // Isso garante que quando o widget for construído, a imagem já esteja
    // decodificada e pronta, eliminando o "jank" (lentidão) inicial.
    // -----------------------------------------------------------
    for (String assetPath in background) {
      precacheImage(AssetImage(assetPath), context);
    }
  }

  void nextPage() {
    if (pos < background.length - 1) {
      setState(() {
        pos = pos + 1;
      });
    } else {
      // Redireciona para a Home e remove a tela de onboarding da pilha
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fundo (agora instantâneo)
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              // Usamos um Builder para garantir que o AssetImage seja criado
              // dentro do BuildContext, embora o precache já tenha feito o trabalho pesado.
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
                        minimumSize: const Size(
                          double.infinity,
                          56,
                        ), // Aumentei um pouco o tamanho para melhor toque
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.black.withOpacity(
                          0.7,
                        ), // Escureci levemente para melhor contraste
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: nextPage,
                      child: Text(
                        pos < 2 ? 'Próximo Passo' : 'Vamos Iniciar',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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

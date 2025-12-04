import 'package:flutter/material.dart';

void main() => runApp(CadastroFinalizadoApp());

class CadastroFinalizadoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EndForm(),
    );
  }
}

class EndForm extends StatelessWidget {
  void _comecarAcao(BuildContext context) {
    // Ação do botão "Começar!"
    //print("Começar pressionado!");

    // Mostrar Snackbar de confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            const Text('Redirecionando para o app...'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ),
    );

    // Aqui você pode navegar para a tela principal
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => TelaPrincipal()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bool isPortrait = height > width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CABEÇALHO ROXO
              Container(
                width: width,
                height: height * 0.25,
                decoration: const BoxDecoration(
                  color: Color(0xFF8250C3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Cadastro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPortrait ? 50 : 35,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // IMAGEM DE CONFIRMAÇÃO
              SizedBox(height: height * 0.05),
              Container(
                width: isPortrait ? width * 0.5 : width * 0.3,
                height: isPortrait ? width * 0.5 : width * 0.3,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(20),
                //  image: const DecorationImage(
               //    fit: BoxFit.contain,
                  ),
                ),
             // ),

              // TÍTULO "CADASTRO FINALIZADO"
              SizedBox(height: height * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Cadastro Finalizado!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF454545),
                    fontSize: isPortrait ? 36 : 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // MENSAGEM DE BOAS-VINDAS
              SizedBox(height: height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Seja Bem-vindo ao SmartManager!\nAproveite nossos recursos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF8F9BB3),
                    fontSize: isPortrait ? 20 : 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),

              // BOTÃO "COMEÇAR!"
              SizedBox(height: height * 0.1),
              GestureDetector(
                onTap: () => _comecarAcao(context),
                child: Container(
                  width: isPortrait ? width * 0.6 : width * 0.4,
                  height: isPortrait ? 60 : 50,
                  decoration: BoxDecoration(
                    color: const Color(0xCC8250C3),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Começar!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isPortrait ? 32 : 24,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),

              // BONUS: Ícone decorativo (opcional)
              SizedBox(height: height * 0.05),
              if (isPortrait) ...[
                _buildDecoratedIcon(),
                SizedBox(height: height * 0.03),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Widget para criar um ícone decorado (similar ao desenho no seu código original)
  Widget _buildDecoratedIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
      ),
      child: Stack(
        children: [
          // Cabeça
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Corpo
          Positioned(
            left: 30,
            top: 42,
            child: Container(
              width: 20,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF8250C3).withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
          ),

          // Detalhes
          Positioned(
            left: 35,
            top: 20,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 35,
            top: 20,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
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
    // Mostrar Snackbar de confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            const Text('Redirecionando para sua homepage...'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ),
    );
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
                width: isPortrait ? width * 0.3 : width * 0.3,
                height: isPortrait ? width * 0.3 : width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/taskcompleted.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

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

              // ESPAÇO FINAL
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
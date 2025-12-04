import 'package:flutter/material.dart';
import 'package:flutter/material.dart';


void main() => runApp(SmartManagerApp());

class SmartManagerApp extends StatelessWidget {
  const SmartManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartManager',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TOPO ROXO
              Container(
                width: width,
                height: height * 0.28,
                decoration: const BoxDecoration(
                  color: Color(0xFF8250C3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Seja Bem-Vindo!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "SmartManager",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              _CampoEntrada(
                label: "Nome de Usuário",
                icon: Icons.person,
              ),

              const SizedBox(height: 20),

              _CampoEntrada(
                label: "Senha",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: width * 0.70,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xCC8250C3),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon (
                        Icons.email,
                        size: width * 0.055,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10), // espaço entre ícone e texto
                      Text(
                        "Entrar com E-mail",
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Esqueceu a senha? ",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: width * 0.04,
                      ),
                    ),
                    const TextSpan(
                      text: "Recupere aqui",
                      style: TextStyle(
                        color: Color(0xFF10A760),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampoEntrada extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;

  const _CampoEntrada({
    required this.label,
    required this.icon,
    this.isPassword = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEDF1F7)),
        ),
        child: TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            icon: Icon(icon, size: 30, color: Colors.grey[600]),
            hintText: label,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: width * 0.045,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(SmartManagerApp());

class SmartManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CadastroScreen(),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  // CONTROLLERS
  final userController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  String? genero;

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
                height: height * 0.25,
                decoration: const BoxDecoration(
                  color: Color(0xFF8250C3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Cadastro",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              _campo("Nome de Usuário", userController),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.40,
                    child: _campo("Primeiro nome", firstNameController),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: width * 0.40,
                    child: _campo("Sobrenome", lastNameController),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              _campo("E-Mail", emailController),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.40,
                    child: _dropdown(),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: width * 0.40,
                    child: _campo("Idade", ageController),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              _campo("Senha", passwordController),

              const SizedBox(height: 40),

              // BOTÃO SALVAR -
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Adicionar lógica de cadastro aqui
                     // print("Botão salvar pressionado");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4FF0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'SALVAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFB39DDB),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
//fim salvar
  // CAMPO PADRÃO
  Widget _campo(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // DROPDOWN GÊNERO
  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: genero,
          hint: const Text("Gênero"),
          items: const [
            DropdownMenuItem(value: "Masculino", child: Text("Masculino")),
            DropdownMenuItem(value: "Feminino", child: Text("Feminino")),
            DropdownMenuItem(value: "Gambiarra", child: Text("Gambiarra")),
          ],
          onChanged: (value) {
            setState(() => genero = value);
          },
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
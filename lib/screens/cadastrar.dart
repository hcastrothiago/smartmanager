import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Importações dos Widgets Padronizados
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/input_form.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final userController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  String? genero;
  bool loading = false;

  @override
  void dispose() {
    // Prática recomendada: sempre limpar os controllers
    userController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    ageController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DefaultScreen já injeta o gradiente roxo e a AppBar
    return DefaultScreen(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image(
                image: const AssetImage('assets/images/user_profile.png'),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),

              // Uso do widget InputForm para manter a identidade
              InputForm(
                placeholder: "Nome de Usuário",
                controller: userController,
              ),

              Row(
                children: [
                  Expanded(
                    child: InputForm(
                      placeholder: "Primeiro Nome",
                      controller: firstNameController,
                    ),
                  ),
                  Expanded(
                    child: InputForm(
                      placeholder: "Sobrenome",
                      controller: lastNameController,
                    ),
                  ),
                ],
              ),

              InputForm(placeholder: "E-mail", controller: emailController),

              Row(
                children: [
                  Expanded(child: _buildGenderDropdown()),
                  Expanded(
                    child: InputForm(
                      placeholder: "Idade",
                      controller: ageController,
                    ),
                  ),
                ],
              ),

              InputForm(placeholder: "Senha", controller: passwordController),

              const SizedBox(height: 40),

              // Botão Salvar Estilizado
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loading ? null : _cadastrarUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'FINALIZAR CADASTRO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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

  // Dropdown adaptado para o visual transparente/branco
  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: genero,
        dropdownColor: const Color(0xFF8250C3), // Cor do gradiente inicial
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Gênero",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        items: [
          "Masculino",
          "Feminino",
          "Outro",
        ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (val) => setState(() => genero = val),
      ),
    );
  }

  Future<void> _cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
            'username': userController.text.trim(),
            'firstName': firstNameController.text.trim(),
            'lastName': lastNameController.text.trim(),
            'email': emailController.text.trim(),
            'idade': int.tryParse(ageController.text) ?? 0,
            'genero': genero,
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Erro no cadastro'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}

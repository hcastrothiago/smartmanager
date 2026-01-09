import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Importações dos Widgets Padronizados
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/input_form.dart';
import 'package:smartmanager/widgets/button.dart';
import 'package:smartmanager/widgets/dropdown_list.dart';

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
    return DefaultScreen(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Image(
                image: AssetImage('assets/images/user_profile.png'),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),

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

              // ALINHAMENTO CORRIGIDO: Removido o Padding redundante
              Row(
                children: [
                  Expanded(
                    child: DropdownList(
                      values: const ["Masculino", "Feminino", "Outro"],
                      initialValue: genero,
                      hint: "Selecione o Gênero",
                      onChanged: (val) => setState(() => genero = val),
                    ),
                  ),
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

              // BOTÃO REFATORADO: Limpeza de paddings aninhados
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Button(label: 'SALVAR', onPressed: _cadastrarUsuario),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
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

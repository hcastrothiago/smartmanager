import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  // 🔹 CHAVE DO FORMULÁRIO (necessária para validação)
  final _formKey = GlobalKey<FormState>();

  // 🔹 CONTROLLERS
  final userController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  String? genero;
  bool loading = false; // 🔹 controla loading do botão

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            // 🔹 FORM envolve todos os campos
            key: _formKey,
            child: Column(
              children: [
                // TOPO
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

                _campo(
                  "E-mail",
                  emailController,
                  isEmail: true,
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: width * 0.40, child: _dropdown()),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: width * 0.40,
                      child: _campo(
                        "Idade",
                        ageController,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                _campo(
                  "Senha",
                  passwordController,
                  isPassword: true,
                ),

                const SizedBox(height: 40),

                // 🔹 BOTÃO SALVAR
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : _cadastrarUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4FF0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'SALVAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 FUNÇÃO DE CADASTRO NO FIREBASE
  Future<void> _cadastrarUsuario() async {
    // valida formulário
    if (!_formKey.currentState!.validate()) return;

    if (genero == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione o gênero")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // 🔥 CRIA USUÁRIO NO FIREBASE AUTH
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 🔥 SALVA DADOS NO FIRESTORE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'username': userController.text.trim(),
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'idade': int.parse(ageController.text),
        'genero': genero,
        'createdAt': Timestamp.now(),
      });

      // 🔹 navega após sucesso
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erro no cadastro')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  // 🔹 CAMPO PADRÃO (TextFormField + validação)
  Widget _campo(
      String hint,
      TextEditingController controller, {
        bool isPassword = false,
        bool isEmail = false,
        bool isNumber = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword, // 🔹 senha protegida
        keyboardType:
        isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          if (isEmail && !value.contains('@')) {
            return 'E-mail inválido';
          }
          if (isPassword && value.length < 6) {
            return 'Mínimo 6 caracteres';
          }
          return null;
        },
      ),
    );
  }

  // 🔹 DROPDOWN GÊNERO
  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
            DropdownMenuItem(value: "Outro", child: Text("Outro")),
          ],
          onChanged: (value) {
            setState(() => genero = value);
          },
        ),
      ),
    );
  }
}

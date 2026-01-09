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

                _campo("E-mail", emailController, isEmail: true),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: width * 0.40, child: _dropdown()),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: width * 0.40,
                      child: _campo("Idade", ageController, isNumber: true),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                _campo("Senha", passwordController, isPassword: true),

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
    // 1. Validação inicial
    if (!_formKey.currentState!.validate()) return;

    if (genero == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione o gênero"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // 2. CRIA USUÁRIO NO FIREBASE AUTH
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 3. SALVA DADOS NO FIRESTORE
      try {
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
      } catch (e) {
        // Se houver erro no Firestore mas o usuário foi criado no Auth,
        // ainda consideramos sucesso e redirecionamos
        print('Erro ao salvar no Firestore: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Usuário criado, mas houve erro ao salvar dados adicionais."),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      // Verifica se o widget ainda está montado antes de continuar
      if (!mounted) return;

      // Feedback de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sucesso! Cadastro realizado. Redirecionando..."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }

      // Pequena pausa para o usuário ver o feedback
      await Future.delayed(const Duration(milliseconds: 1000));

      // Verifica novamente se o widget ainda está montado antes de navegar
      if (!mounted) return;

      // REDIRECIONAMENTO PARA A TELA DE LOGIN
      // Garante que o redirecionamento aconteça mesmo se houver algum problema
      if (mounted) {
        // Desabilita o loading antes de navegar
        setState(() => loading = false);
        
        // Pequeno delay para garantir que o estado foi atualizado
        await Future.delayed(const Duration(milliseconds: 100));
        
        if (!mounted) return;
        
        // Navega para a tela de login
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Erro no cadastro'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Captura qualquer outra exceção não esperada
      print('Erro inesperado: $e');
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper para mensagens (DRY - Don't Repeat Yourself)
  void _mostrarMensagem(String texto, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: erro ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
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

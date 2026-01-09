import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 🔹 CONTROLLERS
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 🔹 CHAVE DO FORMULÁRIO (necessária para validação)
  final _formKey = GlobalKey<FormState>();

  // 🔹 Controla loading do botão
  bool loading = false;

  // 🔹 Controla visibilidade da senha
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // TOPO ROXO
                Container(
                  width: width,
                  height: height * 0.28,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 81, 28, 150),
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
                  label: "E-mail",
                  icon: Icons.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                _CampoEntrada(
                  label: "Senha",
                  icon: Icons.lock,
                  controller: passwordController,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: width * 0.70,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: loading ? null : _fazerLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xCC8250C3),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                      elevation: 0,
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email,
                                size: width * 0.055,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
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

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cadastrar');
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Criar Conta",
                          style: TextStyle(
                            color: Color(0xCC8250C3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 FUNÇÃO DE LOGIN NO FIREBASE
  Future<void> _fazerLogin() async {
    // 1. Validação dos campos ANTES de validar o formulário
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Verifica se os campos estão vazios
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha todos os campos."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Valida formato do e-mail
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, insira um e-mail válido."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Valida tamanho da senha
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A senha deve ter no mínimo 6 caracteres."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 2. Validação do formulário (mostra erros visuais nos campos)
    if (!_formKey.currentState!.validate()) {
      // Se a validação falhar, não continua
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, corrija os erros nos campos."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 3. Se chegou aqui, os campos estão válidos - inicia o loading
    setState(() => loading = true);

    try {
      // 3. FAZ LOGIN NO FIREBASE AUTH
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Verifica se o login foi realmente bem-sucedido
      if (userCredential.user == null) {
        setState(() => loading = false);
        throw FirebaseAuthException(
          code: 'operation-not-allowed',
          message: 'Falha na autenticação',
        );
      }

      // Verifica se o usuário está realmente autenticado
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.uid != userCredential.user!.uid) {
        setState(() => loading = false);
        throw FirebaseAuthException(
          code: 'operation-not-allowed',
          message: 'Falha na autenticação',
        );
      }

      // Verifica se o widget ainda está montado antes de continuar
      if (!mounted) {
        setState(() => loading = false);
        return;
      }

      // Feedback de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login realizado com sucesso!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // Pequena pausa para o usuário ver o feedback
      await Future.delayed(const Duration(milliseconds: 1000));

      // Verifica novamente se o widget ainda está montado antes de navegar
      if (!mounted) {
        setState(() => loading = false);
        return;
      }

      // REDIRECIONAMENTO PARA O DASHBOARD - SÓ ACONTECE SE O LOGIN FOI BEM-SUCEDIDO
      setState(() => loading = false);

      // Verificação final antes de redirecionar
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/dashboard_ui', (route) => false);
      } else {
        // Se por algum motivo o usuário não está mais autenticado, mostra erro
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro: usuário não autenticado."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => loading = false);

        String mensagemErro;
        switch (e.code) {
          case 'user-not-found':
            mensagemErro = 'Nenhum usuário encontrado com este e-mail.';
            break;
          case 'wrong-password':
            mensagemErro = 'Senha incorreta.';
            break;
          case 'invalid-email':
            mensagemErro = 'E-mail inválido.';
            break;
          case 'user-disabled':
            mensagemErro = 'Esta conta foi desabilitada.';
            break;
          case 'too-many-requests':
            mensagemErro = 'Muitas tentativas. Tente novamente mais tarde.';
            break;
          default:
            mensagemErro = e.message ?? 'Erro ao fazer login.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagemErro), backgroundColor: Colors.red),
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
}

class _CampoEntrada extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onToggleVisibility;

  const _CampoEntrada({
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onToggleVisibility,
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
        child: TextFormField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            if (label.toLowerCase().contains('e-mail') ||
                label.toLowerCase().contains('email')) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'E-mail inválido';
              }
            }
            if (isPassword && value.length < 6) {
              return 'Mínimo 6 caracteres';
            }
            return null;
          },
          decoration: InputDecoration(
            icon: Icon(icon, size: 30, color: Colors.grey[600]),
            hintText: label,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: width * 0.045,
            ),
            border: InputBorder.none,
            suffixIcon: isPassword && onToggleVisibility != null
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

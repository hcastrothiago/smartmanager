import 'package:flutter/material.dart';
import '/widgets/floating_menu.dart';

///consertar essa tela amanhã

class ScreenTarefas extends StatelessWidget {
  const ScreenTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo com gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8250C3),
                  Color(0xFFFFFCFF),
                ],
              ),
            ),
          ),

          // Faixa superior translúcida
          Container(
            height: size.height * 0.18,
            color: const Color(0x338250C3),
          ),

          // CONTEÚDO PRINCIPAL
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 80),

                // TÍTULO
                const Text(
                  "Tarefas",
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // SUBTÍTULO
                const Text(
                  "Minhas Tarefas",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 60),

                // ÁREA PARA SUA IMAGEM (upload futuramente)
                Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.shade300,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Adicionar imagem\n(aqui)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // TEXTO PRINCIPAL (roxo)
                const Text(
                  "Você ainda não registrou\nsuas tarefas!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: "Kanit",
                    color: Color(0xFF9053E0),
                  ),
                ),
              ],
            ),
          ),

          // BOTÃO DE MENU
          FloatingMenu(
            onAdd: () {
              print("Adicionar tarefa");
            },
            onDelete: () {
              print("Excluir tarefa");
            },
          ),
        ],
      ),
    );
  }
}

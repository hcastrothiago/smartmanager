import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/dropdown_list.dart';
import 'package:smartmanager/widgets/custom_nav_button.dart';
import 'package:smartmanager/widgets/input_form.dart';

class GymWorkouts extends StatelessWidget {
  const GymWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      title: 'Tarefas',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          ),
          DropdownList(
            values: [
              'Selecione o tipo',
              'Cardio',
              'Força',
              'Flexibilidade',
              'Equilíbrio',
              'Corrida',
              'Reunião',
            ],
          ),
          DropdownList(
            values: [
              'Selecione a frequência',
              'Única vez',
              'A cada semana',
              'A cada duas semanas',
              'Diário',
              'Semanal',
              'Mensal',
              'Anual',
            ],
          ),
          DropdownList(
            values: [
              'Duração da Atividade',
              '15 minutos',
              '30 minutos',
              '45 minutos',
              '1 hora',
              '1 hora e 30 minutos',
              '2 horas',
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Calorias estimadas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          InputForm(placeholder: 'Digite aqui'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
          ),
          CustomNavButton(
            label: 'SALVAR',
            textColor: Colors.white,
            borderColor: Colors.white,
            backgroundColor: Color(0xFF8250C3),
            icon: Icons.save,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Sucesso'),
                    content: const Text('Tarefa salva com sucesso!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

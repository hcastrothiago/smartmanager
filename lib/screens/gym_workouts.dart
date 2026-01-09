import 'package:flutter/material.dart';
import 'package:smartmanager/widgets/default_screen.dart';
import 'package:smartmanager/widgets/dropdown_list.dart';
import 'package:smartmanager/widgets/custom_nav_button.dart';
import 'package:smartmanager/widgets/input_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GymWorkouts extends StatefulWidget {
  const GymWorkouts({super.key});

  @override
  State<GymWorkouts> createState() => _GymWorkoutsState();
}

class _GymWorkoutsState extends State<GymWorkouts> {
  // Controllers e variáveis de estado
  final TextEditingController _caloriasController = TextEditingController();
  String? _tipoSelecionado;
  String? _frequenciaSelecionada;
  String? _duracaoSelecionada;
  bool _loading = false;

  @override
  void dispose() {
    _caloriasController.dispose();
    super.dispose();
  }

  Future<void> _salvarTarefa() async {
    // Validação dos campos
    if (_tipoSelecionado == null || _tipoSelecionado == 'Selecione o tipo') {
      _mostrarMensagem(
        'Por favor, selecione o tipo de atividade',
        Colors.orange,
      );
      return;
    }

    if (_frequenciaSelecionada == null ||
        _frequenciaSelecionada == 'Selecione a frequência') {
      _mostrarMensagem('Por favor, selecione a frequência', Colors.orange);
      return;
    }

    if (_duracaoSelecionada == null ||
        _duracaoSelecionada == 'Duração da Atividade') {
      _mostrarMensagem('Por favor, selecione a duração', Colors.orange);
      return;
    }

    if (_caloriasController.text.trim().isEmpty) {
      _mostrarMensagem(
        'Por favor, informe as calorias estimadas',
        Colors.orange,
      );
      return;
    }

    // Verificar se o usuário está autenticado
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _mostrarMensagem(
        'Usuário não autenticado. Faça login novamente.',
        Colors.red,
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Salvar no Firestore
      await FirebaseFirestore.instance.collection('gym_workouts').add({
        'userId': currentUser.uid,
        'tipo': _tipoSelecionado,
        'frequencia': _frequenciaSelecionada,
        'duracao': _duracaoSelecionada,
        'calorias': _caloriasController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Limpar os campos após salvar
      setState(() {
        _tipoSelecionado = null;
        _frequenciaSelecionada = null;
        _duracaoSelecionada = null;
        _caloriasController.clear();
      });

      // Feedback visual de sucesso
      if (mounted) {
        _mostrarMensagem('Tarefa salva com sucesso!', Colors.green);
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensagem('Erro ao salvar tarefa: ${e.toString()}', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

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
            initialValue: _tipoSelecionado ?? 'Selecione o tipo',
            onChanged: (value) {
              setState(() {
                _tipoSelecionado = value;
              });
            },
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
            initialValue: _frequenciaSelecionada ?? 'Selecione a frequência',
            onChanged: (value) {
              setState(() {
                _frequenciaSelecionada = value;
              });
            },
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
            initialValue: _duracaoSelecionada ?? 'Duração da Atividade',
            onChanged: (value) {
              setState(() {
                _duracaoSelecionada = value;
              });
            },
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
          InputForm(
            placeholder: 'Digite aqui',
            controller: _caloriasController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
          ),
          CustomNavButton(
            label: _loading ? 'SALVANDO...' : 'SALVAR',
            textColor: Colors.white,
            borderColor: Colors.white,
            backgroundColor: Color(0xFF8250C3),
            icon: _loading ? Icons.hourglass_empty : Icons.save,
            onPressed: _loading ? null : _salvarTarefa,
          ),
        ],
      ),
    );
  }
}

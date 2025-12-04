# smartmanager
Projeto de aplicativo para nota de PDM 

### O QUE AINDA É NECESSÁRIO FAZER
- Victor: Responsável pela criação da screen de Treinos diários em `lib/screens/gym_workouts.dart`
- Felipe Santos: Responsável pela criação da screen de Gestor Financeiro em `lib/screens/financial_management.dart`
- Heráclito: Responsável pela criação da screen de lista de compras em `lib/screens/shopping_list.dart`
- Heráclito: Unificação dos estilos das telas criadas pela equipe para criação de uma config de temas.

receba
class Group1707478340 extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Column(
children: [
Container(
width: 1080,
height: 1920,
child: Stack(
children: [
Positioned(
left: 0,
top: 0,
child: Container(
width: 1080,
height: 1920,
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment(0.50, -0.00),
end: Alignment(0.50, 1.00),
colors: [const Color(0xFF8250C3), const Color(0xFF8250C3), const Color(0xF28250C3), Colors.white],
),
),
),
),
],
),
),
],
);
}
}
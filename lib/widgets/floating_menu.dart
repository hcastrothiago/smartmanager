import 'package:flutter/material.dart';

class FloatingMenu extends StatefulWidget {
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  const FloatingMenu({
    super.key,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  State<FloatingMenu> createState() => _FloatingMenuState();
}

class _FloatingMenuState extends State<FloatingMenu> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      right: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (opened) ...[
            _MenuButton(
              icon: Icons.add,
              label: "Adicionar tarefas",
              onPressed: widget.onAdd,
            ),
            const SizedBox(height: 10),
            _MenuButton(
              icon: Icons.delete,
              label: "Excluir tarefas",
              onPressed: widget.onDelete,
            ),
            const SizedBox(height: 20),
          ],

          // Botão principal
          GestureDetector(
            onTap: () => setState(() => opened = !opened),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                opened ? Icons.close : Icons.add,
                size: 40,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black87, size: 26),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

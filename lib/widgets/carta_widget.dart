import 'package:flutter/material.dart';

class CartaWidget extends StatelessWidget {
  final String tipo;
  final String valor;
  final bool estaVisible;
  final VoidCallback? onTap;

  // Nuevos parámetros para drag & drop
  final bool draggable;
  final String? dragData;
  final DragTargetAccept<String>? onAccept;
  final DragTargetWillAccept<String>? onWillAccept;

  const CartaWidget({
    super.key,
    required this.tipo,
    required this.valor,
    required this.estaVisible,
    this.onTap,
    this.draggable = false,
    this.dragData,
    this.onAccept,
    this.onWillAccept,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Card(
      elevation: 4,
      child: Container(
        alignment: Alignment.center,
        color: Colors.blueGrey.shade50,
        child: estaVisible
            ? (tipo == 'imagen'
                ? Image.network(valor, fit: BoxFit.cover)
                : Text(valor, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
            : const Icon(Icons.help_outline, size: 40, color: Colors.grey),
      ),
    );

    // Si la carta es draggable (por ejemplo, cartas de texto en emparejamiento)
    if (draggable && dragData != null) {
      return Draggable<String>(
        data: dragData!,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 100,
            child: cardContent,
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.4, child: cardContent),
        child: GestureDetector(
          onTap: onTap,
          child: cardContent,
        ),
      );
    }

    // Si la carta es un DragTarget (por ejemplo, cartas de imagen en emparejamiento)
    if (onAccept != null && onWillAccept != null) {
      return DragTarget<String>(
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            onTap: onTap,
            child: cardContent,
          );
        },
        onWillAccept: onWillAccept,
        onAccept: onAccept,
      );
    }

    // Caso normal: solo tap (para memorama u otros usos)
    return GestureDetector(
      onTap: onTap,
      child: cardContent,
    );
  }
}

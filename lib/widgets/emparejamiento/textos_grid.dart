import 'package:flutter/material.dart';
import 'package:language_world/models/carta.dart';

class TextosGrid extends StatelessWidget {
  final List<Carta> textos;
  final Map<String, bool> emparejadas;

  const TextosGrid({
    Key? key,
    required this.textos,
    required this.emparejadas,
  }) : super(key: key);

  Widget _buildTextoCard(String texto) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            shadows: [
              Shadow(blurRadius: 2, color: Colors.white70, offset: Offset(0, 0)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: textos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        final textoCarta = textos[index];
        final estaEmparejada = emparejadas[textoCarta.idCarta] ?? false;

        if (estaEmparejada) return const SizedBox.shrink();

        return Draggable<String>(
          data: textoCarta.idCarta,
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                ],
              ),
              child: Text(
                textoCarta.valor,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: _buildTextoCard(textoCarta.valor),
          ),
          child: _buildTextoCard(textoCarta.valor),
        );
      },
    );
  }
}

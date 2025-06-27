import 'package:flutter/material.dart';
import 'package:language_world/models/carta.dart';

class ImagenesGrid extends StatelessWidget {
  final List<Carta> imagenes;
  final Map<String, bool> emparejadas;
  final void Function(String id1, String id2) onEmparejar;

  const ImagenesGrid({
    Key? key,
    required this.imagenes,
    required this.emparejadas,
    required this.onEmparejar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imagenes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final imagenCarta = imagenes[index];
        final estaEmparejada = emparejadas[imagenCarta.idCarta] ?? false;

        return DragTarget<String>(
          builder: (context, candidateData, rejectedData) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: estaEmparejada ? Colors.green[100] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: estaEmparejada ? Colors.green : Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Image.network(imagenCarta.valor, fit: BoxFit.contain),
            );
          },
          onWillAccept: (data) => data == imagenCarta.parejaId && !estaEmparejada,
          onAccept: (data) {
            onEmparejar(imagenCarta.idCarta, data);
          },
        );
      },
    );
  }
}

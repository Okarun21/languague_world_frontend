import 'package:flutter/material.dart';
import 'package:language_world/models/carta.dart';
import 'package:language_world/widgets/carta_widget.dart';

class CartasGrid extends StatelessWidget {
  final List<Carta> cartas;
  final List<bool> visibles;
  final void Function(int index) onTap;

  const CartasGrid({
    Key? key,
    required this.cartas,
    required this.visibles,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: cartas.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final carta = cartas[index];
        return CartaWidget(
          tipo: carta.tipo,
          valor: carta.valor,
          estaVisible: visibles[index],
          onTap: () => onTap(index),
        );
      },
    );
  }
}

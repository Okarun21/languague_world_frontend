import 'package:flutter/material.dart';

class CartaWidget extends StatelessWidget {
  final String tipo;
  final String valor;
  final bool estaVisible;
  final VoidCallback onTap;

  const CartaWidget({
    super.key,
    required this.tipo,
    required this.valor,
    required this.estaVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
      ),
    );
  }
}
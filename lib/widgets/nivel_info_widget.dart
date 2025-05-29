import 'package:flutter/material.dart';

class NivelInfoWidget extends StatelessWidget {
  final String nombre;
  final String dificultad;
  final String idioma;
  final String tematica;

  const NivelInfoWidget({
    super.key,
    required this.nombre,
    required this.dificultad,
    required this.idioma,
    required this.tematica,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nivel: $nombre', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Dificultad: $dificultad'),
        Text('Idioma: $idioma'),
        Text('Temática: $tematica'),
      ],
    );
  }
}
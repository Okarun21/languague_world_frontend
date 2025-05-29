import 'carta.dart';

class Nivel {
  final String id;
  final String nombre;
  final String idioma;
  final String dificultad;
  final String tematica;
  final List<String> tags;
  final String creador;
  final bool publico;
  final int puntuacionMaxima;
  final int tiempoRecomendadoSegundos;
  final List<Carta> cartas;

  Nivel({
    required this.id,
    required this.nombre,
    required this.idioma,
    required this.dificultad,
    required this.tematica,
    required this.tags,
    required this.creador,
    required this.publico,
    required this.puntuacionMaxima,
    required this.tiempoRecomendadoSegundos,
    required this.cartas,
  });

  factory Nivel.fromJson(Map<String, dynamic> json) {
    var cartasJson = json['cartas'] as List;
    List<Carta> cartasList = cartasJson.map((c) => Carta.fromJson(c)).toList();

    return Nivel(
      id: json['_id'],
      nombre: json['nombre'],
      idioma: json['idioma'],
      dificultad: json['dificultad'],
      tematica: json['tematica'],
      tags: List<String>.from(json['tags']),
      creador: json['creador'],
      publico: json['publico'],
      puntuacionMaxima: json['puntuacion_maxima'],
      tiempoRecomendadoSegundos: json['tiempo_recomendado_segundos'],
      cartas: cartasList,
    );
  }
}

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
  final String modo;
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
    required this.modo,
    required this.tiempoRecomendadoSegundos,
    required this.cartas,
  });

  /// Función para parsear el campo _id que puede ser String o Map con $oid
  static String parseId(dynamic idField) {
    if (idField == null) return '';
    if (idField is String) return idField;
    if (idField is Map && idField.containsKey('\$oid')) {
      return idField['\$oid'] ?? '';
    }
    return '';
  }

  factory Nivel.fromJson(Map<String, dynamic> json) {
    var cartasJson = json['cartas'];
    List<dynamic> cartasListDynamic;

    if (cartasJson is List) {
      cartasListDynamic = cartasJson;
    } else if (cartasJson is Map) {
      cartasListDynamic = cartasJson.values.toList();
    } else {
      cartasListDynamic = [];
    }

    List<Carta> cartasList =
        cartasListDynamic.map((c) => Carta.fromJson(c)).toList();

    return Nivel(
      id: parseId(json['_id']),
      nombre: json['nombre'] ?? 'Sin nombre',
      idioma: json['idioma'] ?? 'desconocido',
      dificultad: json['dificultad'] ?? 'desconocida',
      tematica: json['tematica'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      creador: json['creador'] ?? '',
      publico: json['publico'] ?? false,
      puntuacionMaxima: json['puntuacion_maxima'] ?? 0,
      modo: json['modo'] ?? 'memorama',
      tiempoRecomendadoSegundos: json['tiempo_recomendado_segundos'] ?? 60,
      cartas: cartasList,
    );
  }
}

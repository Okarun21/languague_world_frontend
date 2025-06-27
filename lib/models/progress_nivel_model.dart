class ProgressNivelModel {
  final String nivelId;
  final DateTime fechaCompletado;
  final int puntuacion;
  final int tiempoSegundos;

  ProgressNivelModel({
    required this.nivelId,
    required this.fechaCompletado,
    required this.puntuacion,
    required this.tiempoSegundos,
  });

  factory ProgressNivelModel.fromJson(Map<String, dynamic> json) {
    return ProgressNivelModel(
      nivelId: json['nivel_id'],
      fechaCompletado: DateTime.parse(json['fecha_completado']),
      puntuacion: json['puntuacion'],
      tiempoSegundos: json['tiempo_segundos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nivel_id': nivelId,
      'fecha_completado': fechaCompletado.toIso8601String(),
      'puntuacion': puntuacion,
      'tiempo_segundos': tiempoSegundos,
    };
  }

  ProgressNivelModel copyWith({
    String? nivelId,
    DateTime? fechaCompletado,
    int? puntuacion,
    int? tiempoSegundos,
  }) {
    return ProgressNivelModel(
      nivelId: nivelId ?? this.nivelId,
      fechaCompletado: fechaCompletado ?? this.fechaCompletado,
      puntuacion: puntuacion ?? this.puntuacion,
      tiempoSegundos: tiempoSegundos ?? this.tiempoSegundos,
    );
  }
}

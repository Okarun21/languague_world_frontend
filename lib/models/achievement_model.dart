class AchievementModel {
  final String nombre;
  final String descripcion;
  final DateTime fechaObtenido;
  final String icono;

  AchievementModel({
    required this.nombre,
    required this.descripcion,
    required this.fechaObtenido,
    required this.icono,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaObtenido: DateTime.parse(json['fecha_obtenido']),
      icono: json['icono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_obtenido': fechaObtenido.toIso8601String(),
      'icono': icono,
    };
  }
}

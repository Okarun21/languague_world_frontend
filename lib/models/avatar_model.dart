class AvatarModel {
  final String? base;
  final String? colorPiel;
  final String? peinado;
  final String? sombrero;
  final String? camisa;
  final String? pantalon;
  final String? zapatos;
  final List<String>? accesorios;
  final DateTime? fechaActualizacion;

  AvatarModel({
    this.base,
    this.colorPiel,
    this.peinado,
    this.sombrero,
    this.camisa,
    this.pantalon,
    this.zapatos,
    this.accesorios,
    this.fechaActualizacion,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      base: json['base'],
      colorPiel: json['color_piel'],
      peinado: json['peinado'],
      sombrero: json['sombrero'],
      camisa: json['camisa'],
      pantalon: json['pantalon'],
      zapatos: json['zapatos'],
      accesorios: json['accesorios'] != null ? List<String>.from(json['accesorios']) : null,
      fechaActualizacion: json['fecha_actualizacion'] != null ? DateTime.parse(json['fecha_actualizacion']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base': base,
      'color_piel': colorPiel,
      'peinado': peinado,
      'sombrero': sombrero,
      'camisa': camisa,
      'pantalon': pantalon,
      'zapatos': zapatos,
      'accesorios': accesorios,
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }
}

import 'achievement_model.dart';
import 'avatar_model.dart';
import 'progress_model.dart';

class ProfileModel {
  final String cuentaId;
  final String nombreUsuario;
  final String fotoPerfil;
  final DateTime fechaCreacion;
  final int nivelUsuario;
  final AvatarModel? avatar;
  final ProgressModel? progreso;
  final List<AchievementModel> logros;

  ProfileModel({
    required this.cuentaId,
    required this.nombreUsuario,
    this.fotoPerfil = "",
    required this.fechaCreacion,
    this.nivelUsuario = 1,
    this.avatar,
    this.progreso,
    this.logros = const [],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      cuentaId: json['cuenta_id'],
      nombreUsuario: json['nombre_usuario'],
      fotoPerfil: json['fotoPerfil'] ?? "",
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      nivelUsuario: json['nivel_usuario'] ?? 1,
      avatar: json['avatar'] != null ? AvatarModel.fromJson(json['avatar']) : null,
      progreso: json['progreso'] != null ? ProgressModel.fromJson(json['progreso']) : null,
      logros: json['logros'] != null
          ? (json['logros'] as List).map((e) => AchievementModel.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cuenta_id': cuentaId,
      'nombre_usuario': nombreUsuario,
      'fotoPerfil': fotoPerfil,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'nivel_usuario': nivelUsuario,
      'avatar': avatar?.toJson(),
      'progreso': progreso?.toJson(),
      'logros': logros.map((e) => e.toJson()).toList(),
    };
  }
}

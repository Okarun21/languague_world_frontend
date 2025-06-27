import 'package:language_world/models/progress_nivel_model.dart';

class ProgressModel {
  final List<ProgressNivelModel>? es;
  final List<ProgressNivelModel>? en;
  final List<ProgressNivelModel>? fr;

  ProgressModel({this.es, this.en, this.fr});

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    List<ProgressNivelModel>? parseList(dynamic list) {
      if (list == null) return null;
      return (list as List)
          .map((e) => ProgressNivelModel.fromJson(e))
          .toList();
    }

    return ProgressModel(
      es: parseList(json['es']),
      en: parseList(json['en']),
      fr: parseList(json['fr']),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? listToJson(List<ProgressNivelModel>? list) {
      if (list == null) return null;
      return list.map((e) => e.toJson()).toList();
    }

    return {
      'es': listToJson(es),
      'en': listToJson(en),
      'fr': listToJson(fr),
    };
  }

  int get puntos {
    int total = 0;
    void sumar(List<ProgressNivelModel>? list) {
      if (list == null) return;
      for (var nivel in list) {
        total += nivel.puntuacion;
      }
    }
    sumar(es);
    sumar(en);
    sumar(fr);
    return total;
  }

  ProgressModel copyWith({
    List<ProgressNivelModel>? es,
    List<ProgressNivelModel>? en,
    List<ProgressNivelModel>? fr,
  }) {
    return ProgressModel(
      es: es ?? this.es,
      en: en ?? this.en,
      fr: fr ?? this.fr,
    );
  }
}

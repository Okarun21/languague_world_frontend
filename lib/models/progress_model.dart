import 'package:language_world/models/progress_nivel_model.dart';

class ProgressModel {
  final Map<String, List<ProgressNivelModel>>? es;
  final Map<String, List<ProgressNivelModel>>? en;
  final Map<String, List<ProgressNivelModel>>? fr;

  ProgressModel({
    this.es,
    this.en,
    this.fr,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      es: _parseMap(json['es']),
      en: _parseMap(json['en']),
      fr: _parseMap(json['fr']),
    );
  }

  static Map<String, List<ProgressNivelModel>>? _parseMap(dynamic map) {
    if (map == null) return null;
    return (map as Map<String, dynamic>).map((key, value) {
      final list = (value as List).map((e) => ProgressNivelModel.fromJson(e)).toList();
      return MapEntry(key, list);
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'es': es?.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
      'en': en?.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
      'fr': fr?.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:language_world/models/levels.dart';

class NivelProvider extends ChangeNotifier {
  List<Nivel> _niveles = [];
  String _idiomaSeleccionado = 'es';

  Nivel? _nivelSeleccionado;

  List<Nivel> get nivelesFiltrados =>
      _niveles.where((nivel) => nivel.idioma == _idiomaSeleccionado).toList();

  String get idiomaSeleccionado => _idiomaSeleccionado;

  set idiomaSeleccionado(String idioma) {
    if (_idiomaSeleccionado != idioma) {
      _idiomaSeleccionado = idioma;
      notifyListeners();
    }
  }

  Nivel? get nivelSeleccionado => _nivelSeleccionado;

  set nivelSeleccionado(Nivel? nivel) {
    _nivelSeleccionado = nivel;
    notifyListeners();
  }

  void setNiveles(List<Nivel> niveles) {
    _niveles = niveles;
    notifyListeners();
  }

  // MÉTODO QUE FALTA: seleccionarNivel
  void seleccionarNivel(Nivel nivel) {
    _nivelSeleccionado = nivel;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:language_world/models/levels.dart';

class NivelProvider extends ChangeNotifier {
  Nivel? _nivelSeleccionado;

  Nivel? get nivelSeleccionado => _nivelSeleccionado;

  void seleccionarNivel(Nivel nivel) {
    _nivelSeleccionado = nivel;
    notifyListeners();
  }

  void limpiarSeleccion() {
    _nivelSeleccionado = null;
    notifyListeners();
  }
}

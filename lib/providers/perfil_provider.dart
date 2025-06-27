import 'package:flutter/material.dart';
import 'package:language_world/models/levels.dart'; // Tu modelo Nivel
import 'package:language_world/models/perfil_model.dart';
import 'package:language_world/models/progress_nivel_model.dart';
import 'package:language_world/services/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profile;
  String _idiomaSeleccionado = 'en';

  List<Nivel> _niveles = [];
  List<Nivel> get niveles => _niveles;

  ProfileModel? get profile => _profile;
  String get idiomaSeleccionado => _idiomaSeleccionado;

  set idiomaSeleccionado(String idioma) {
    if (_idiomaSeleccionado != idioma) {
      _idiomaSeleccionado = idioma;
      notifyListeners();
    }
  }

  List<ProgressNivelModel>? get progresoIdioma {
    if (_profile == null) return null;

    switch (_idiomaSeleccionado) {
      case 'es':
        return _profile!.progreso?.es;
      case 'en':
        return _profile!.progreso?.en;
      case 'fr':
        return _profile!.progreso?.fr;
      default:
        return null;
    }
  }

  void setProfile(ProfileModel profile) {
    _profile = profile;
    notifyListeners();
  }

  void actualizarNivelUsuario(int nuevoNivel) {
    if (_profile != null) {
      _profile = _profile!.copyWith(nivelUsuario: nuevoNivel);
      notifyListeners();
    }
  }

  void agregarProgresoNivel(ProgressNivelModel nuevoProgreso) {
    if (_profile == null) return;

    final progresoActual = _profile!.progreso;

    List<ProgressNivelModel> lista;

    switch (_idiomaSeleccionado) {
      case 'es':
        lista = List.from(progresoActual?.es ?? []);
        lista.add(nuevoProgreso);
        _profile = _profile!.copyWith(progreso: progresoActual?.copyWith(es: lista));
        break;
      case 'en':
        lista = List.from(progresoActual?.en ?? []);
        lista.add(nuevoProgreso);
        _profile = _profile!.copyWith(progreso: progresoActual?.copyWith(en: lista));
        break;
      case 'fr':
        lista = List.from(progresoActual?.fr ?? []);
        lista.add(nuevoProgreso);
        _profile = _profile!.copyWith(progreso: progresoActual?.copyWith(fr: lista));
        break;
      default:
        return;
    }

    notifyListeners();
  }

  /// Carga la lista de niveles desde el backend
  Future<void> cargarNiveles() async {
    try {
      _niveles = await ApiService().fetchNiveles();
      notifyListeners();
    } catch (e) {
      print('Error cargando niveles: $e');
    }
  }

  /// Obtiene el nombre del nivel dado su id de forma segura
  String nombreNivelPorId(String nivelId) {
    final nivel = _niveles.firstWhere(
      (nivel) => nivel.id == nivelId,
      orElse: () => Nivel(
        id: nivelId,
        nombre: 'Nivel desconocido',
        idioma: '',
        dificultad: '',
        tematica: '',
        tags: [],
        creador: '',
        publico: false,
        puntuacionMaxima: 0,
        modo: '',
        tiempoRecomendadoSegundos: 0,
        cartas: [],
      ),
    );
    return nivel.nombre;
  }

  Future<void> refreshProfile() async {
    if (_profile == null) return;

    try {
      final perfilActualizado = await ApiService().getProfile(_profile!.cuentaId);
      if (perfilActualizado != null) {
        final nuevoProfileModel = ProfileModel.fromJson(perfilActualizado);
        _profile = nuevoProfileModel;
        notifyListeners();
      }
    } catch (e) {
      print('Error al refrescar perfil: $e');
    }
  }
}

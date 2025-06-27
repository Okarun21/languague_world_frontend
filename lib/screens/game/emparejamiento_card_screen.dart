import 'dart:async';
import 'package:flutter/material.dart';
import 'package:language_world/models/progress_nivel_model.dart';
import 'package:language_world/providers/nivel_provider.dart';
import 'package:language_world/providers/perfil_provider.dart';
import 'package:language_world/services/api_service.dart';
import 'package:language_world/widgets/emparejamiento/imagenes_grid.dart';
import 'package:language_world/widgets/emparejamiento/textos_grid.dart';
import 'package:provider/provider.dart';
import 'package:language_world/models/carta.dart';

class EmparejamientoScreen extends StatefulWidget {
  const EmparejamientoScreen({super.key});

  @override
  State<EmparejamientoScreen> createState() => _EmparejamientoScreenState();
}

class _EmparejamientoScreenState extends State<EmparejamientoScreen> {
  late List<Carta> cartas;
  late List<Carta> imagenes;
  late List<Carta> textos;
  final Map<String, bool> emparejadas = {};
  bool completado = false;

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _segundosTranscurridos = 0;

  @override
  void initState() {
    super.initState();
    final nivel = Provider.of<NivelProvider>(context, listen: false).nivelSeleccionado;
    if (nivel == null) {
      cartas = [];
      imagenes = [];
      textos = [];
    } else {
      cartas = nivel.cartas
          .map(
            (c) => Carta(
              idCarta: c.idCarta,
              tipo: c.tipo,
              valor: c.valor,
              posicion: c.posicion,
              parejaId: c.parejaId,
            ),
          )
          .toList();

      imagenes = List<Carta>.from(cartas.where((c) => c.tipo == 'imagen'));
      textos = List<Carta>.from(cartas.where((c) => c.tipo == 'texto'));

      imagenes.shuffle();
      textos.shuffle();
    }
    for (var carta in cartas) {
      emparejadas[carta.idCarta] = false;
    }

    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _segundosTranscurridos = _stopwatch.elapsed.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  int _calcularPuntos(int segundos) {
    if (segundos <= 30) return 100;
    if (segundos <= 60) return 70;
    if (segundos <= 90) return 50;
    return 30;
  }

  Future<void> _guardarProgresoYNivelConProviders(
      int puntos, ProfileProvider profileProvider, NivelProvider nivelProvider) async {
    final profile = profileProvider.profile;
    final nivel = nivelProvider.nivelSeleccionado;

    if (profile == null || nivel == null) return;

    final progresoNivel = ProgressNivelModel(
      nivelId: nivel.id,
      fechaCompletado: DateTime.now(),
      puntuacion: puntos,
      tiempoSegundos: _segundosTranscurridos,
    );

    try {
      // Guardar progreso en backend
      await ApiService().actualizarProgresoNivel(
        cuentaId: profile.cuentaId,
        idioma: nivel.idioma,
        progresoNivel: progresoNivel,
      );

      // Calcular nuevos puntos y nivel
      int nuevosPuntos = (profile.progreso?.puntos ?? 0) + puntos;
      int nuevoNivel = (nuevosPuntos ~/ 100) + 1;

      // Actualizar nivel en backend y provider si subió
      if (nuevoNivel > profile.nivelUsuario) {
        await ApiService().actualizarNivelUsuario(
          cuentaId: profile.cuentaId,
          nivelUsuario: nuevoNivel,
        );
        profileProvider.actualizarNivelUsuario(nuevoNivel);
      }

      // Actualizar progreso local agregando el nuevo nivel completado
      profileProvider.agregarProgresoNivel(progresoNivel);

      // Refresca el perfil para ver el progreso actualizado
      await profileProvider.refreshProfile();
    } catch (e) {
      print('Error guardando progreso: $e');
    }
  }

  void _checkCompletion() {
    if (emparejadas.values.every((v) => v)) {
      _stopwatch.stop();
      _timer?.cancel();
      setState(() {
        completado = true;
      });

      int puntos = _calcularPuntos(_segundosTranscurridos);
      _showCompletionDialog(puntos);
    }
  }

  void _showCompletionDialog(int puntos) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final nivelProvider = Provider.of<NivelProvider>(context, listen: false);
    final parentContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¡Felicidades!'),
        content: Text(
          'Completaste el juego en $_segundosTranscurridos segundos.\nPuntos obtenidos: $puntos',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _guardarProgresoYNivelConProviders(puntos, profileProvider, nivelProvider);
              if (!mounted) return;
              Navigator.pop(parentContext); // Vuelve a niveles o pantalla anterior
            },
            child: const Text('Volver a Niveles'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cartas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Emparejamiento')),
        body: const Center(
          child: Text('No se ha seleccionado ningún nivel o no hay cartas'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Empareja las palabras - Tiempo: $_segundosTranscurridos s',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ImagenesGrid(
                imagenes: imagenes,
                emparejadas: emparejadas,
                onEmparejar: (id1, id2) {
                  setState(() {
                    emparejadas[id1] = true;
                    emparejadas[id2] = true;
                  });
                  _checkCompletion();
                },
              ),
              const SizedBox(height: 24),
              TextosGrid(textos: textos, emparejadas: emparejadas),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:language_world/models/carta.dart';
import 'package:language_world/models/progress_nivel_model.dart';
import 'package:language_world/providers/nivel_provider.dart';
import 'package:language_world/providers/perfil_provider.dart';
import 'package:language_world/routes/routes.dart';
import 'package:language_world/services/api_service.dart';
import 'package:language_world/widgets/memorama/cartas_grid.dart';
import 'package:language_world/widgets/nivel_info_widget.dart';
import 'package:provider/provider.dart';

class MemoramaScreen extends StatefulWidget {
  const MemoramaScreen({super.key});

  @override
  State<MemoramaScreen> createState() => _MemoramaScreenState();
}

class _MemoramaScreenState extends State<MemoramaScreen> {
  late List<bool> visibles;
  late List<Carta> _cartasBarajadas;
  int? indexCartaSeleccionada;
  bool _bloqueado = false;
  bool _completado = false;

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _segundosTranscurridos = 0;

  @override
  void initState() {
    super.initState();
    final nivel = Provider.of<NivelProvider>(context, listen: false).nivelSeleccionado!;
    _cartasBarajadas = List.of(nivel.cartas);
    _cartasBarajadas.shuffle();
    visibles = List.filled(_cartasBarajadas.length, false);

    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
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
    } catch (e) {
      print('Error guardando progreso: $e');
    }
  }

  void _mostrarDialogoFinal(int puntos) {
    // Extraemos providers ANTES de abrir el diálogo para evitar errores de contexto
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final nivelProvider = Provider.of<NivelProvider>(context, listen: false);
    final parentContext = context; // Guardamos el context padre para navegación

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¡Felicidades!'),
        content: Text(
          'Completaste el memorama en $_segundosTranscurridos segundos.\n'
          'Puntos obtenidos: $puntos',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Cerramos diálogo con su context
              await _guardarProgresoYNivelConProviders(puntos, profileProvider, nivelProvider);
              if (!mounted) return;
              // Navegamos con el context padre guardado
              Navigator.pushNamedAndRemoveUntil(
                parentContext,
                Routes.niveles,
                (route) => false,
              );
            },
            child: const Text('Volver a Niveles'),
          ),
        ],
      ),
    );
  }

  void onCartaTap(int index) {
    if (_bloqueado || visibles[index] || _completado) return;

    setState(() {
      visibles[index] = true;

      if (indexCartaSeleccionada == null) {
        indexCartaSeleccionada = index;
      } else {
        if (_cartasBarajadas[index].parejaId ==
            _cartasBarajadas[indexCartaSeleccionada!].idCarta) {
          indexCartaSeleccionada = null;

          if (visibles.every((v) => v)) {
            _completado = true;
            _stopwatch.stop();
            _timer?.cancel();
            int puntos = _calcularPuntos(_segundosTranscurridos);
            _mostrarDialogoFinal(puntos);
          }
        } else {
          _bloqueado = true;
          int primerIndex = indexCartaSeleccionada!;
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              visibles[index] = false;
              visibles[primerIndex] = false;
              indexCartaSeleccionada = null;
              _bloqueado = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nivel = Provider.of<NivelProvider>(context).nivelSeleccionado;

    if (nivel == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Memorama'),
        ),
        body: const Center(child: Text('No se ha seleccionado ningún nivel')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Memorama - ${nivel.nombre} - Tiempo: $_segundosTranscurridos s'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NivelInfoWidget(
              nombre: nivel.nombre,
              dificultad: nivel.dificultad,
              idioma: nivel.idioma,
              tematica: nivel.tematica,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: CartasGrid(
                cartas: _cartasBarajadas,
                visibles: visibles,
                onTap: onCartaTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:language_world/models/progress_nivel_model.dart';
import 'package:language_world/providers/perfil_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProfileStatsScreen extends StatefulWidget {
  const ProfileStatsScreen({super.key});

  @override
  State<ProfileStatsScreen> createState() => _ProfileStatsScreenState();
}

class _ProfileStatsScreenState extends State<ProfileStatsScreen> {
  bool _nivelesCargados = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_nivelesCargados) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.cargarNiveles().then((_) {
        if (mounted) {
          setState(() {
            _nivelesCargados = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Estadísticas')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final progreso = profile.progreso;
    final puntosTotales = progreso?.puntos ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usuario: ${profile.nombreUsuario}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Nivel actual: ${profile.nivelUsuario}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              'Puntos acumulados: $puntosTotales',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            const Text(
              'Progreso por idioma:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildIdiomaProgreso(context, 'Español', progreso?.es, profileProvider),
                  _buildIdiomaProgreso(context, 'Inglés', progreso?.en, profileProvider),
                  _buildIdiomaProgreso(context, 'Francés', progreso?.fr, profileProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdiomaProgreso(
    BuildContext context,
    String idiomaNombre,
    List<ProgressNivelModel>? progresoIdioma,
    ProfileProvider profileProvider,
  ) {
    if (progresoIdioma == null || progresoIdioma.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('$idiomaNombre: Sin progreso'),
      );
    }

    // Agrupar la lista de progreso por nivelId
    final Map<String, List<ProgressNivelModel>> progresoPorNivel =
        groupBy(progresoIdioma, (ProgressNivelModel p) => p.nivelId);

    List<Widget> nivelesWidgets = [];

    progresoPorNivel.forEach((nivelId, listaProgreso) {
      final nombreNivel = profileProvider.nombreNivelPorId(nivelId);
      nivelesWidgets.add(
        ExpansionTile(
          title: Text('Nivel: $nombreNivel'),
          children: listaProgreso.map((progreso) {
            return ListTile(
              title: Text('Puntuación: ${progreso.puntuacion}'),
              subtitle: Text(
                'Completado el: ${progreso.fechaCompletado.toLocal().toString().split(' ')[0]} - Tiempo: ${progreso.tiempoSegundos}s',
              ),
            );
          }).toList(),
        ),
      );
    });

    return ExpansionTile(
      title: Text(idiomaNombre),
      children: nivelesWidgets,
    );
  }
}

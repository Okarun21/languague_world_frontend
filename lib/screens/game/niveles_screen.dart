import 'package:flutter/material.dart';
import 'package:language_world/models/levels.dart';
import 'package:language_world/providers/nivel_provider.dart';
import 'package:language_world/routes/routes.dart';
import 'package:language_world/services/api_service.dart';
import 'package:provider/provider.dart';

class NivelScreen extends StatefulWidget {
  const NivelScreen({super.key});

  @override
  State<NivelScreen> createState() => _NivelScreenState();
}

class _NivelScreenState extends State<NivelScreen> {
  late Future<List<Nivel>> futureNiveles;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureNiveles = apiService.fetchNiveles();
  }

  @override
  Widget build(BuildContext context) {
    final nivelProvider = Provider.of<NivelProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            );
          },
        ),
        title: const Text('Selecciona un Nivel'),
      ),
      body: FutureBuilder<List<Nivel>>(
        future: futureNiveles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay niveles disponibles'));
          } else {
            final niveles = snapshot.data!;
            return ListView.builder(
              itemCount: niveles.length,
              itemBuilder: (context, index) {
                final nivel = niveles[index];
                return ListTile(
                  title: Text(nivel.nombre),
                  subtitle: Text(
                    'Dificultad: ${nivel.dificultad} - Idioma: ${nivel.idioma}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    nivelProvider.seleccionarNivel(nivel);
                    if (nivel.modo == 'memorama') {
                      Navigator.pushNamed(context, Routes.memorama);
                    } else if (nivel.modo == 'emparejamiento') {
                      Navigator.pushNamed(context, Routes.emparejamiento);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Modo de juego no definido para este nivel',
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
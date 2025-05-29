import 'dart:io'; // Para exit(0)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para SystemNavigator.pop()
import 'package:language_world/services/api_service.dart';
import 'package:language_world/utils/shared_prefs_utils.dart';
import 'package:language_world/widgets/profile_info_for_home.dart';
import 'package:language_world/widgets/languague_selector.dart';
import 'package:language_world/routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  String? userId;
  String username = '';
  int nivel = 0;
  String profileImageUrl = '';
  bool isLoading = true;
  String? errorMessage;
  String selectedLanguage = 'es';

  @override
  void initState() {
    super.initState();
    cargarUserIdYPerfil();
  }

  Future<void> cargarUserIdYPerfil() async {
    final storedUserId = await getUserId();

    if (storedUserId == null) {
      setState(() {
        errorMessage = 'No hay usuario logueado';
        isLoading = false;
      });
      return;
    }

    setState(() {
      userId = storedUserId;
    });

    try {
      final perfilData = await apiService.getProfile(userId!);
      if (perfilData != null) {
        setState(() {
          username = perfilData['nombre_usuario'] ?? 'Sin nombre';
          nivel = int.tryParse(perfilData['nivel_usuario'].toString()) ?? 0;
          profileImageUrl = perfilData['fotoPerfil'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Perfil no encontrado';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar perfil: $e';
        isLoading = false;
      });
    }
  }

  void _salirApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop(); // Cierra la app en Android
    } else if (Platform.isIOS) {
      exit(0); // Cierra la app en iOS (no recomendado por Apple)
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Perfil y configuración en fila con selector de idioma debajo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna con perfil + selector idioma
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileInfoForHome(
                        profileImageUrl: profileImageUrl,
                        username: username,
                        nivel: nivel,
                      ),
                      const SizedBox(height: 12),
                      LanguageSelector(
                        selectedLanguage: selectedLanguage,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedLanguage = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  // Botón configuración
                  IconButton(
                    icon: const Icon(Icons.settings),
                    iconSize: 28,
                    onPressed: () {
                      // Acción configuración
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Avatar centrado sin recortes ni formas
            Expanded(
              child: Center(
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_0Z9vczPMuuS6TjElwsy9RZRUSWj80XWVgw&s',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Botón jugar centrado abajo con padding
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.niveles);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    'JUGAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    elevation: 4,
                  ),
                ),
              ),
            ),

            // Botón salir centrado abajo con padding
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _salirApp,
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text(
                    'SALIR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    elevation: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

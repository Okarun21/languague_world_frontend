import 'package:flutter/material.dart';
import 'package:language_world/routes/routes.dart';
import 'package:language_world/widgets/avatar_widget.dart';
import 'package:language_world/widgets/languague_selector.dart';
import 'package:language_world/widgets/profile_info_for_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedLanguage = 'es';

  @override
  Widget build(BuildContext context) {
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
                      const ProfileInfoForHome(
                        profileImageUrl:
                            'https://cdn-icons-png.freepik.com/256/14723/14723787.png',
                        username: 'OmarcitoGamer',
                        nivel: 1,
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
                      print('Configuración presionada');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Avatar centrado
            const Expanded(
              child: Center(
                child: AvatarWidget(
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
                ),
              ),
            ),

            // Botón jugar centrado abajo con padding
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navegar a la pantalla de niveles
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
          ],
        ),
      ),
    );
  }
}

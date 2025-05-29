import 'package:flutter/material.dart';
import 'package:language_world/widgets/select_icon_perfil.dart';
import 'package:language_world/services/api_service.dart';
import 'package:language_world/models/profile_icon.dart';

class PicturePerfilScreen extends StatefulWidget {
  const PicturePerfilScreen({super.key});

  @override
  State<PicturePerfilScreen> createState() => _PicturePerfilScreenState();
}

class _PicturePerfilScreenState extends State<PicturePerfilScreen> {
  List<ProfileIcon> icons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIcons();
  }

  Future<void> _loadIcons() async {
    try {
      final apiService = ApiService();
      final loadedIcons = await apiService.fetchProfileIcons();
      setState(() {
        icons = loadedIcons;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar los iconos: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu foto de perfil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : SelectIconPerfil(
                    icons: icons,
                    initialIcon: null,
                    userId: '',
                  ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:language_world/models/profile_icon.dart';
import 'package:language_world/services/api_service.dart';
import 'package:language_world/widgets/select_icon_perfil.dart';


class PicturePerfilScreen extends StatefulWidget {
  const PicturePerfilScreen({super.key});

  @override
  State<PicturePerfilScreen> createState() => _PicturePerfilScreenState();
}

class _PicturePerfilScreenState extends State<PicturePerfilScreen> {
  List<ProfileIcon> icons = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadIcons();
  }

  void _loadIcons() async {
    try {
      final apiService = ApiService();
      final result = await apiService.fetchProfileIcons();
      setState(() {
        icons = result;
        loading = false;
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona tu foto de perfil'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(16.0),
          child: loading
              ? const CircularProgressIndicator()
              : SelectIconPerfil(
                  icons: icons, userId: '',
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:language_world/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:language_world/services/api_service.dart';
import 'package:language_world/widgets/username_form.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _apiService = ApiService();
  String? backendError;

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<bool> usernameExists(String nombreUsuario) async {
    try {
      final response = await _apiService.usernameExists(nombreUsuario.trim());
      return response;
    } catch (e) {
      return false;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final nombreUsuario = _usernameController.text.trim();
      final userId = await getUserId();
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se encontró el ID de la cuenta')),
        );
        return;
      }

      try {
        final exists = await usernameExists(nombreUsuario);
        if (exists) {
          setState(() {
            backendError = 'El nombre de usuario ya está en uso';
          });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El nombre de usuario ya está en uso')),
          );
          return;
        }

        // Usa el parámetro correcto según la nueva definición de ApiService
        await _apiService.createProfile(
          userId: userId,
          nombreUsuario: nombreUsuario,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil creado con éxito')),
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.picturePerfil,
          (route) => false,
        );
      } catch (e) {
        setState(() {
          backendError = 'Error al crear el perfil: $e';
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el perfil: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: UsernameForm(
            usernameController: _usernameController,
            onSubmit: _submit,
            backendError: backendError,
          ),
        ),
      ),
    );
  }
}

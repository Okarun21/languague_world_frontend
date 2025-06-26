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
  bool _isLoading = false;

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<bool> usernameExists(String nombreUsuario) async {
    final response = await _apiService.usernameExists(nombreUsuario.trim());
    if (response.error != null) {
      // Puedes mostrar un mensaje o loguear el error si quieres
      return false;
    }
    return response.data ?? false;
  }

  void _submit() async {
    setState(() {
      backendError = null;
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      final nombreUsuario = _usernameController.text.trim();
      final userId = await getUserId();
      if (userId == null) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se encontró el ID de la cuenta'),
          ),
        );
        return;
      }

      final exists = await usernameExists(nombreUsuario);
      if (exists) {
        setState(() {
          backendError = 'El nombre de usuario ya está en uso';
          _isLoading = false;
        });
        _formKey.currentState!.validate();
        return;
      }

      final createResponse = await _apiService.createProfile(
        userId: userId,
        nombreUsuario: nombreUsuario,
      );

      if (createResponse.error != null) {
        setState(() {
          backendError = 'Error al crear el perfil: ${createResponse.error}';
          _isLoading = false;
        });
        _formKey.currentState!.validate();
        return;
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil creado con éxito')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.picturePerfil,
        (route) => false,
      );
    } else {
      setState(() {
        _isLoading = false;
      });
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
      appBar: AppBar(title: const Text('Username')),
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

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterController {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  final ApiService _apiService = ApiService();

  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    passwordController.dispose();
  }

  Future<void> registerUser(
    BuildContext context, {
    required VoidCallback onEmailExists,
  }) async {
    final name = nombreController.text.trim();
    final email = correoController.text.trim();
    final password = passwordController.text;

    try {
      await _apiService.registerUser(name, email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado con éxito')),
      );
      goToLogin(context);
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('email') && errorMsg.contains('existe')) {
        onEmailExists();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

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

  Future<void> registerUser({
    required VoidCallback onSuccess,
    required VoidCallback onEmailExists,
    required Function(String) onError,
  }) async {
    final name = nombreController.text.trim();
    final email = correoController.text.trim();
    final password = passwordController.text;

    try {
      final account = await _apiService.registerUser(name, email, password);
      final userId = account.id;

      onSuccess();
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('email') && errorMsg.contains('existe')) {
        onEmailExists();
      } else {
        onError(e.toString());
      }
    }
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

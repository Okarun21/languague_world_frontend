import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../routes/routes.dart';

enum LoginResult {
  success,
  invalidEmail,
  invalidPassword,
  error,
}

class LoginController {
  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  final ApiService _apiService = ApiService();

  void dispose() {
    correoController.dispose();
    passwordController.dispose();
  }

  void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, Routes.register);
  }

  Future<LoginResult> loginUser(BuildContext context) async {
    try {
      await _apiService.loginUser(
        correoController.text,
        passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso')),
      );
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
      return LoginResult.success;
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('email') || errorMessage.contains('correo')) {
        return LoginResult.invalidEmail;
      } else if (errorMessage.contains('password') || errorMessage.contains('contraseña')) {
        return LoginResult.invalidPassword;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        return LoginResult.error;
      }
    }
  }
}

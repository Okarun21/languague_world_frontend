import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LoginController {
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void dispose() {
    correoController.dispose();
    passwordController.dispose();
  }

  Future<void> loginUser({
    required void Function(String userId) onSuccess,
    required void Function(String message) onError,
  }) async {
    final email = correoController.text.trim();
    final password = passwordController.text;

    final result = await _apiService.loginUser(email, password);

    if (result.error != null) {
      onError(result.error!);
    } else if (result.data != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', result.data!.id);
      onSuccess(result.data!.id);
    } else {
      onError('Error desconocido');
    }
  }
}

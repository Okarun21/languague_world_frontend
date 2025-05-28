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
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final email = correoController.text.trim();
    final password = passwordController.text;

    try {
      final account = await _apiService.loginUser(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', account.id);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }
}

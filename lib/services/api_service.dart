import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account_model.dart';

class ApiService {
  static const String baseUrl = 'https://languague-world-backend.onrender.com';

  Future<List<AccountModel>> fetchAccounts() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AccountModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body)['error'] ?? 'Error desconocido';
      throw Exception(error);
    }
  }

  Future<void> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final error =
          jsonDecode(response.body)['error'] ?? 'Error de autenticación';
      throw Exception(error);
    }
  }
}

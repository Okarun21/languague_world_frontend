import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:language_world/models/profile_icon.dart';
import '../models/account_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Login
  Future<AccountModel> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Error de autenticación';
      throw Exception(error);
    }
  }

  // Registro
  Future<AccountModel> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Error desconocido';
      throw Exception(error);
    }
  }

  // Crear perfil
  Future<void> createProfile({
    required String userId,
    required String username,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cuenta_id': userId, 'nombre_usuario': username}),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body)['error'] ?? 'Error al crear el perfil';
      throw Exception(error);
    }
  }

  // Validar si el username existe
  Future<bool> usernameExists(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/check-username?username=$username'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] ?? false;
    } else {
      throw Exception('Error al validar el username');
    }
  }

  // Obtener iconos de perfil
  Future<List<ProfileIcon>> fetchProfileIcons() async {
    final response = await http.get(Uri.parse('$baseUrl/images/profiles'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => ProfileIcon.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los iconos');
    }
  }

  // Obtener perfil por userId
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener el perfil');
    }
  }
}

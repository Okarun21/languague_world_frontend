import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:language_world/models/levels.dart';
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
      final error =
          jsonDecode(response.body)['error'] ?? 'Error de autenticación';
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
    required String nombreUsuario,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cuenta_id': userId, 'nombre_usuario': nombreUsuario}),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el perfil: ${response.body}');
    }
  }

  // Validar si el nombre de usuario existe
  Future<bool> usernameExists(String nombreUsuario) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/profile/check-username?nombre_usuario=$nombreUsuario',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] ?? false;
    } else {
      throw Exception('Error al validar el nombre de usuario');
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
    final response = await http.get(Uri.parse('$baseUrl/profile/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener el perfil');
    }
  }

  Future<void> updateProfileIcon({
    required String userId,
    required String iconUrl,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/$userId/icon'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'iconUrl': iconUrl}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el icono');
    }
  }

  // Actualizar idioma de perfil
  Future<void> updateProfileLanguage({
    required String userId,
    required String language,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/$userId/language'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'language': language}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el idioma');
    }
  }

  Future<List<Nivel>> fetchNiveles() async {
    final response = await http.get(Uri.parse('$baseUrl/levels'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Nivel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar niveles: ${response.statusCode}');
    }
  }
}

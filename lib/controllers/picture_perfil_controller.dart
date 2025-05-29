import 'package:flutter/foundation.dart';
import 'package:language_world/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicturePerfilController with ChangeNotifier {
  final ApiService apiService;

  PicturePerfilController(this.apiService);

  Future<void> saveProfileIcon(String iconUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) throw Exception('Usuario no autenticado');
    await apiService.updateProfileIcon(userId: userId, iconUrl: iconUrl);
    notifyListeners();
  }
}

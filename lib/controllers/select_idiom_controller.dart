import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectIdiomController with ChangeNotifier {
  Future<void> saveLanguageLocally(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
    notifyListeners();
  }

  Future<String?> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedLanguage');
  }
}

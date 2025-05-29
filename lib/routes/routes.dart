import 'package:flutter/material.dart';
import 'package:language_world/screens/game/memorama_screen.dart';
import 'package:language_world/screens/game/niveles_screen.dart';
import 'package:language_world/screens/game/select_idiom_screen.dart';
import '../screens/auth/screens_auth.dart';
import '../screens/game/screens_game.dart';

class Routes {
  static const String launcher = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String login = '/login';
  static const String username = '/username';
  static const String picturePerfil = '/picturePerfil';
  static const String selectIdiom = '/selectIdiom';
  static const String niveles = '/nivelesScreen';
  static const String memorama = '/memoramaScreen';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      register: (context) => RegisterScreen(),
      home: (context) => HomeScreen(),
      login: (context) => LoginScreen(),
      username: (context) => UsernameScreen(),
      picturePerfil: (context) => PicturePerfilScreen(),
      selectIdiom: (context) => SelectIdiomScreen(),
      niveles: (context) => NivelScreen(),
      memorama: (context) => MemoramaScreen(),

    };
  }
}

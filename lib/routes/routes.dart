import 'package:flutter/material.dart';
import 'package:language_world/screens/home_screen.dart';
import 'package:language_world/screens/auth/login_screen.dart';
import 'package:language_world/screens/auth/register_screen.dart';

class Routes {
  static const String launcher = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String login = '/login'; 

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //launcher: (context) => LauncherScreen(),
      register: (context) => RegisterScreen(),
      home: (context) => HomeScreen(),
      login: (context) => LoginScreen(), 
    };
  }
}

import 'package:flutter/material.dart';
import 'package:language_world/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.register,
      routes: Routes.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}






















































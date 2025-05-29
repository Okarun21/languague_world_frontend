import 'package:flutter/material.dart';
import 'package:language_world/providers/nivel_provider.dart';
import 'package:provider/provider.dart';
import 'package:language_world/services/api_service.dart';
import 'package:language_world/controllers/picture_perfil_controller.dart';
import 'package:language_world/routes/routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiService()),
        ChangeNotifierProvider(create: (context) => PicturePerfilController(context.read<ApiService>())),
         ChangeNotifierProvider(create: (_) => NivelProvider()),
      ],
      child: const MyApp(),
    ),
  );
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

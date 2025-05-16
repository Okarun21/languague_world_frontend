import 'package:flutter/material.dart';
import 'package:language_world/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: RegisterForm(),
      ),
    );
  }
}

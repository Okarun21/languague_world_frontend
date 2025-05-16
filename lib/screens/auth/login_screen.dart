import 'package:flutter/material.dart';
import 'package:language_world/widgets/login_form.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: LoginForm(),
      ),
    );
  }
}

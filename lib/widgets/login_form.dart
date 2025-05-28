import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState!.validate()) {
      await _controller.loginUser(
        onSuccess: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sesión iniciada con éxito')),
          );
          Navigator.of(context).pushReplacementNamed('/username');
        },
        onError: (message) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $message')),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hint: 'Correo',
            icon: Icons.email,
            controller: _controller.correoController,
            validator: (value) => validateCorreo(value),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hint: 'Contraseña',
            icon: Icons.lock,
            obscure: true,
            controller: _controller.passwordController,
            validator: (value) => validatePassword(value),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _onLogin,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

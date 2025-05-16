import 'package:flutter/material.dart';
import 'package:language_world/controllers/login_controller.dart';
import 'package:language_world/utils/validators.dart';
import 'package:language_world/widgets/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LoginController();

  String? _emailBackendError;
  String? _passwordBackendError;
  bool _isLoading = false;

  String? validateCorreoWithBackendError(String? value) {
    return validateCorreo(value, _emailBackendError);
  }

  String? validatePasswordWithBackendError(String? value) {
    return validatePassword(value, _passwordBackendError);
  }

  Future<void> _onLogin() async {
    setState(() {
      _emailBackendError = null;
      _passwordBackendError = null;
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      final loginResult = await _controller.loginUser(context);

      if (loginResult == LoginResult.invalidEmail) {
        setState(() {
          _emailBackendError = 'Correo no registrado';
        });
        _formKey.currentState!.validate();
      } else if (loginResult == LoginResult.invalidPassword) {
        setState(() {
          _passwordBackendError = 'Contraseña incorrecta';
        });
        _formKey.currentState!.validate();
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            validator: validateCorreoWithBackendError,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hint: 'Contraseña',
            icon: Icons.lock,
            obscure: true,
            controller: _controller.passwordController,
            validator: validatePasswordWithBackendError,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _onLogin,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.green,
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
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

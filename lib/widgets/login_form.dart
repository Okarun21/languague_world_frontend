import 'package:flutter/material.dart';
import 'package:language_world/routes/routes.dart';
import '../controllers/login_controller.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../services/api_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LoginController();
  bool _isLoading = false;
  String? _correoError;   
  String? _passwordError; 

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    setState(() {
      _correoError = null;
      _passwordError = null;
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      await _controller.loginUser(
        onSuccess: (String userId) async {
          if (!mounted) return;
          final apiService = ApiService();
          final profile = await apiService.getProfile(userId);
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          if (profile != null) {
            Navigator.of(context).pushReplacementNamed(Routes.home);
          } else {
            Navigator.of(context).pushReplacementNamed(Routes.username);
          }
        },
        onError: (String message) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
            if (message == 'Correo no registrado') {
              _correoError = message;
            } else if (message == 'Contraseña incorrecta') {
              _passwordError = message;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $message')),
              );
            }
            _formKey.currentState!.validate();
          });
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
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
            validator: (value) => validateCorreo(value, _correoError),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hint: 'Contraseña',
            icon: Icons.lock,
            obscure: true,
            controller: _controller.passwordController,
            validator: (value) => validatePassword(value, _passwordError),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _onLogin,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.green,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
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

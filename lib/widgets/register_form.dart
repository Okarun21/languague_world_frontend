import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';
import '../utils/validators.dart';
import 'custom_text_field.dart';
import 'login_redirect_text.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = RegisterController();

  String? _emailBackendError;

  String? validateCorreoWithBackendError(String? value) {
    return validateCorreo(value, _emailBackendError);
  }

  Future<void> _onRegister() async {
    setState(() => _emailBackendError = null);

    if (_formKey.currentState!.validate()) {
      await _controller.registerUser(
        context,
        onEmailExists: () {
          setState(() {
            _emailBackendError = 'El correo ya está en uso';
          });
          _formKey.currentState!.validate();
        },
      );
    }
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
            hint: 'Nombre',
            icon: Icons.person,
            controller: _controller.nombreController,
            validator: validateNombre,
          ),
          const SizedBox(height: 8),
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
            validator: validatePassword,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _onRegister,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Registrarse',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          LoginRedirectText(onTap: () => _controller.goToLogin(context)),
        ],
      ),
    );
  }
}

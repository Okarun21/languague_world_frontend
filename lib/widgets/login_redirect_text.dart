import 'package:flutter/material.dart';

class LoginRedirectText extends StatelessWidget {
  final VoidCallback onTap;

  const LoginRedirectText({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        '¿Ya tienes una cuenta? Inicia sesión',
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

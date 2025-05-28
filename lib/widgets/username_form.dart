import 'package:flutter/material.dart';

class UsernameForm extends StatelessWidget {
  final TextEditingController usernameController;
  final VoidCallback onSubmit;
  final String? backendError;

  const UsernameForm({
    super.key,
    required this.usernameController,
    required this.onSubmit,
    this.backendError,
  });

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un nombre de usuario';
    }
    if (backendError != null) {
      return backendError;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Nombre de usuario',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) => validateUsername(value),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

String? validateNombre(String? value) {
  if (value == null || value.isEmpty) return 'Por favor ingresa tu nombre';
  return null;
}

String? validateCorreo(String? value, [String? backendError]) {
  if (value == null || value.isEmpty) return 'Por favor ingresa tu correo';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) return 'Correo inválido';
  if (backendError != null) return backendError; // Mostrar error backend
  return null;
}

String? validatePassword(String? value, [String? backendError]) {
  if (value == null || value.isEmpty) return 'Por favor ingresa una contraseña';
  if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
  if (backendError != null) return backendError; // Mostrar error backend
  return null;
}

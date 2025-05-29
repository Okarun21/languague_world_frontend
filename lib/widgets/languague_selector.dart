import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String?> onChanged;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  final List<Map<String, String>> languages = const [
    {'code': 'es', 'name': 'Español'},
    {'code': 'en', 'name': 'English'},
    // Agrega más idiomas aquí si quieres
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: selectedLanguage,
        underline: const SizedBox(),
        iconEnabledColor: Colors.black87,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        items: languages.map((lang) {
          return DropdownMenuItem<String>(
            value: lang['code'],
            child: Text(lang['name']!),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:language_world/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectIdiom extends StatefulWidget {
  const SelectIdiom({super.key});

  @override
  State<SelectIdiom> createState() => _SelectIdiomState();
}

class _SelectIdiomState extends State<SelectIdiom> {
  String? selectedLanguage;
  final languages = [
    {'code': 'es', 'name': 'Español'},
    {'code': 'en', 'name': 'English'},
  ];

  Future<void> _guardarIdiomaSeleccionado(String idioma) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idioma_seleccionado', idioma);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selecciona el idioma que quieres aprender',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  hint: const Text('Selecciona idioma'),
                  icon: const Icon(Icons.language),
                  isExpanded: true,
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue;
                    });
                  },
                  items:
                      languages.map<DropdownMenuItem<String>>((lang) {
                        return DropdownMenuItem<String>(
                          value: lang['code'],
                          child: Text(lang['name']!),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                ),
                onPressed:
                    selectedLanguage == null
                        ? null
                        : () async {
                          await _guardarIdiomaSeleccionado(selectedLanguage!);
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.home,
                            (route) => false,
                          );
                        },
                child: const Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

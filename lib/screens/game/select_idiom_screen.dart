import 'package:flutter/material.dart';
import 'package:language_world/widgets/select_idiom.dart';

class SelectIdiomScreen extends StatelessWidget {
  const SelectIdiomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un idioma'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: const Center(child: SelectIdiom()),
    );
  }
}

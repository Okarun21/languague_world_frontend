import 'package:flutter/material.dart';
import 'package:language_world/models/carta.dart';
import 'package:language_world/providers/nivel_provider.dart';
import 'package:language_world/widgets/carta_widget.dart';
import 'package:language_world/widgets/nivel_info_widget.dart';
import 'package:language_world/routes/routes.dart';
import 'package:provider/provider.dart';

class MemoramaScreen extends StatefulWidget {
  const MemoramaScreen({super.key});

  @override
  State<MemoramaScreen> createState() => _MemoramaScreenState();
}

class _MemoramaScreenState extends State<MemoramaScreen> {
  late List<bool> visibles;
  late List<Carta> _cartasBarajadas;
  int? indexCartaSeleccionada;
  bool _bloqueado = false;
  bool _completado = false;

  @override
  void initState() {
    super.initState();
    final nivel =
        Provider.of<NivelProvider>(context, listen: false).nivelSeleccionado!;
    _cartasBarajadas = List.of(nivel.cartas);
    _cartasBarajadas.shuffle();
    visibles = List.filled(_cartasBarajadas.length, false);
  }

  void onCartaTap(int index) {
    if (_bloqueado || visibles[index] || _completado) return;

    setState(() {
      visibles[index] = true;

      if (indexCartaSeleccionada == null) {
        indexCartaSeleccionada = index;
      } else {
        if (_cartasBarajadas[index].parejaId ==
            _cartasBarajadas[indexCartaSeleccionada!].idCarta) {
          indexCartaSeleccionada = null;

          if (visibles.every((v) => v)) {
            _completado = true;
          }
        } else {
          _bloqueado = true;
          int primerIndex = indexCartaSeleccionada!;
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              visibles[index] = false;
              visibles[primerIndex] = false;
              indexCartaSeleccionada = null;
              _bloqueado = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nivel = Provider.of<NivelProvider>(context).nivelSeleccionado;

    if (nivel == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 16,
          title: const Text(
            'Memorama',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: const Center(child: Text('No se ha seleccionado ningún nivel')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: Text(
          'Memorama - ${nivel.nombre}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NivelInfoWidget(
              nombre: nivel.nombre,
              dificultad: nivel.dificultad,
              idioma: nivel.idioma,
              tematica: nivel.tematica,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: _cartasBarajadas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final carta = _cartasBarajadas[index];
                  return CartaWidget(
                    tipo: carta.tipo,
                    valor: carta.valor,
                    estaVisible: visibles[index],
                    onTap: () => onCartaTap(index),
                  );
                },
              ),
            ),
            if (_completado) ...[
              const SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '¡Felicidades! Completaste el memorama.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.niveles,
                          (route) => false,
                        );
                      },
                      child: const Text('Volver a Niveles'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:language_world/providers/nivel_provider.dart';
import 'package:language_world/widgets/carta_widget.dart';
import 'package:language_world/widgets/nivel_info_widget.dart';
import 'package:provider/provider.dart';


class MemoramaScreen extends StatefulWidget {
  const MemoramaScreen({super.key});

  @override
  State<MemoramaScreen> createState() => _MemoramaScreenState();
}

class _MemoramaScreenState extends State<MemoramaScreen> {
  late List<bool> visibles;
  int? indexCartaSeleccionada;

  @override
  void initState() {
    super.initState();
    final nivel = Provider.of<NivelProvider>(context, listen: false).nivelSeleccionado!;
    visibles = List.filled(nivel.cartas.length, false);
  }

  void onCartaTap(int index) {
    setState(() {
      final nivel = Provider.of<NivelProvider>(context, listen: false).nivelSeleccionado!;
      if (visibles[index]) return;

      visibles[index] = true;

      if (indexCartaSeleccionada == null) {
        indexCartaSeleccionada = index;
      } else {
        if (nivel.cartas[index].parejaId == nivel.cartas[indexCartaSeleccionada!].idCarta) {
          // Pareja correcta
          indexCartaSeleccionada = null;
        } else {
          int primerIndex = indexCartaSeleccionada!;
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              visibles[index] = false;
              visibles[primerIndex] = false;
              indexCartaSeleccionada = null;
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
        appBar: AppBar(title: const Text('Memorama')),
        body: const Center(child: Text('No se ha seleccionado ningún nivel')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Memorama - ${nivel.nombre}')),
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
                itemCount: nivel.cartas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final carta = nivel.cartas[index];
                  return CartaWidget(
                    tipo: carta.tipo,
                    valor: carta.valor,
                    estaVisible: visibles[index],
                    onTap: () => onCartaTap(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

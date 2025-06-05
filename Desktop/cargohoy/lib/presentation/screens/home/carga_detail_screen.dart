import 'package:cargohoy/data/models/carga_model.dart';
import 'package:flutter/material.dart';

class CargaDetailScreen extends StatelessWidget {
  final CargaModel carga;

  const CargaDetailScreen({super.key, required this.carga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Carga')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${carga.tipoCarga}', style: const TextStyle(fontSize: 18)),
            Text('Peso: ${carga.peso} kg', style: const TextStyle(fontSize: 18)),
            Text('Origen: ${carga.origen}', style: const TextStyle(fontSize: 18)),
            Text('Destino: ${carga.destino}', style: const TextStyle(fontSize: 18)),
            Text('Estado: ${carga.estado}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

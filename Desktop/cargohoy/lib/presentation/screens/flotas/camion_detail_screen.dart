import 'package:cargohoy/data/models/camion_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cargohoy/presentation/providers/flota_provider.dart';

class CamionDetailScreen extends StatelessWidget {
  final String camionId;

  const CamionDetailScreen({super.key, required this.camionId});

  @override
  Widget build(BuildContext context) {
    final flotaProvider = Provider.of<FlotaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Camión')),
      body: FutureBuilder(
        future: flotaProvider.getCamionById(camionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final camion = snapshot.data as CamionModel;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Matrícula: ${camion.matricula}',
                      style: const TextStyle(fontSize: 18)),
                  Text('Marca: ${camion.marca}',
                      style: const TextStyle(fontSize: 18)),
                  Text('Modelo: ${camion.modelo}',
                      style: const TextStyle(fontSize: 18)),
                  Text('Capacidad: ${camion.capacidad} toneladas',
                      style: const TextStyle(fontSize: 18)),
                  Text('Fecha de Adquisición: ${camion.fechaAdquisicion}',
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

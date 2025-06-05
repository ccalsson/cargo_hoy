import 'package:cargohoy/data/models/servicio_model.dart';
import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServicioModel servicio;

  const ServiceDetailScreen({super.key, required this.servicio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Servicio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${servicio.tipo}', style: const TextStyle(fontSize: 18)),
            Text('Ubicación: ${servicio.ubicacion}',
                style: const TextStyle(fontSize: 18)),
            Text('Descuentos: ${servicio.descuentos.join(", ")}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reserve_service',
                    arguments: servicio.id);
              },
              child: const Text('Reservar Servicio'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/servicio_provider.dart';

class ServiceReserveScreen extends StatelessWidget {
  final String servicioId;

  const ServiceReserveScreen({super.key, required this.servicioId});

  @override
  Widget build(BuildContext context) {
    final servicioProvider = Provider.of<ServicioProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reservar Servicio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Reservar Servicio ID: $servicioId',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            if (servicioProvider.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  const usuarioId =
                      'usuarioId'; // Reemplazar con ID real del usuario
                  await servicioProvider.reserveServicio(servicioId, usuarioId);
                  if (servicioProvider.errorMessage.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(servicioProvider.errorMessage)),
                    );
                  }
                },
                child: const Text('Confirmar Reserva'),
              ),
          ],
        ),
      ),
    );
  }
}

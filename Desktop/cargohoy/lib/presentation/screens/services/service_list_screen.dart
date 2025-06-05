import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/servicio_provider.dart';
import 'service_detail_screen.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final servicioProvider = Provider.of<ServicioProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios Adicionales')),
      body: servicioProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: servicioProvider.servicios.length,
              itemBuilder: (context, index) {
                final servicio = servicioProvider.servicios[index];
                return ListTile(
                  title: Text(servicio.tipo),
                  subtitle: Text(servicio.ubicacion),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServiceDetailScreen(servicio: servicio),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

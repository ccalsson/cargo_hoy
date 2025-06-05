import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/flota_provider.dart';
import '../../../data/models/flota_model.dart';
import 'camion_detail_screen.dart';

class FlotaDetailScreen extends StatelessWidget {
  final String flotaId;

  const FlotaDetailScreen({super.key, required this.flotaId});

  @override
  Widget build(BuildContext context) {
    final flotaProvider = Provider.of<FlotaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Flota')),
      body: FutureBuilder(
        future: flotaProvider.getFlotaById(flotaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final flota = snapshot.data as FlotaModel;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${flota.id}', style: const TextStyle(fontSize: 18)),
                  Text('Membresía: ${flota.membresia}',
                      style: const TextStyle(fontSize: 18)),
                  const Text('Camiones:', style: TextStyle(fontSize: 18)),
                  ...flota.camiones.map((camionId) {
                    return ListTile(
                      title: Text('Camión $camionId'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CamionDetailScreen(camionId: camionId),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

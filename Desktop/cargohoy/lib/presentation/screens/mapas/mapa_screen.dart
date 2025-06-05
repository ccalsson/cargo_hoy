import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ruta_provider.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rutaProvider = Provider.of<RutaProvider>(context);
    const origen = 'Origen'; // Reemplazar con origen real
    const destino = 'Destino'; // Reemplazar con destino real

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: rutaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : rutaProvider.ruta == null
              ? const Center(child: Text('No hay datos disponibles'))
              : Center(
                  child: Text('Ruta de $origen a $destino'),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await rutaProvider.fetchRuta(origen, destino);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

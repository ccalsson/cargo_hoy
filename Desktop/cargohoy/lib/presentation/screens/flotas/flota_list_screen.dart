import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/flota_provider.dart';
import 'flota_detail_screen.dart';

class FlotaListScreen extends StatelessWidget {
  const FlotaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flotaProvider = Provider.of<FlotaProvider>(context);
    const duenoId = 'duenoId'; // Reemplazar con ID real del dueno

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Flotas')),
      body: flotaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: flotaProvider.flotas.length,
              itemBuilder: (context, index) {
                final flota = flotaProvider.flotas[index];
                return ListTile(
                  title: Text('Flota ${flota.id}'),
                  subtitle: Text('Membresía: ${flota.membresia}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FlotaDetailScreen(flotaId: flota.id),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await flotaProvider.fetchFlotas(duenoId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

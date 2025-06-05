import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/gamificacion_provider.dart';

class PuntosScreen extends StatelessWidget {
  const PuntosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gamificacionProvider = Provider.of<GamificacionProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Puntos y Recompensas')),
      body: gamificacionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : gamificacionProvider.gamificacion == null
              ? const Center(child: Text('No hay datos disponibles'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Puntos: ${gamificacionProvider.gamificacion!.puntos}',
                          style: const TextStyle(fontSize: 18)),
                      const Text('Recompensas:', style: TextStyle(fontSize: 18)),
                      ...gamificacionProvider.gamificacion!.recompensas
                          .map((recompensa) {
                        return ListTile(
                          title: Text(recompensa),
                        );
                      }),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await gamificacionProvider.canjearRecompensa(
                              usuarioId, 'Descuento en Combustible');
                          if (gamificacionProvider.errorMessage.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Recompensa canjeada exitosamente')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(gamificacionProvider.errorMessage)),
                            );
                          }
                        },
                        child: const Text('Canjear Recompensa'),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await gamificacionProvider.fetchGamificacion(usuarioId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

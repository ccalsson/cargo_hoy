import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/gamificacion_provider.dart';

class LogrosScreen extends StatelessWidget {
  const LogrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gamificacionProvider = Provider.of<GamificacionProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Logros')),
      body: gamificacionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : gamificacionProvider.gamificacion == null
              ? const Center(child: Text('No hay datos disponibles'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Logros Desbloqueados:',
                          style: TextStyle(fontSize: 18)),
                      ...gamificacionProvider.gamificacion!.logros.map((logro) {
                        return ListTile(
                          title: Text(logro),
                        );
                      }),
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

import 'package:cargohoy/data/models/configuracion_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/configuracion_provider.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configuracionProvider = Provider.of<ConfiguracionProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: configuracionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : configuracionProvider.configuracion == null
              ? const Center(child: Text('No hay datos disponibles'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Notificaciones Activas'),
                        value: configuracionProvider
                            .configuracion!.notificacionesActivas,
                        onChanged: (value) {
                          final configuracion = ConfiguracionModel(
                            id: configuracionProvider.configuracion!.id,
                            usuarioId:
                                configuracionProvider.configuracion!.usuarioId,
                            notificacionesActivas: value,
                            tema: configuracionProvider.configuracion!.tema,
                          );
                          configuracionProvider
                              .updateConfiguracion(configuracion);
                        },
                      ),
                      DropdownButton<String>(
                        value: configuracionProvider.configuracion!.tema,
                        onChanged: (value) {
                          final configuracion = ConfiguracionModel(
                            id: configuracionProvider.configuracion!.id,
                            usuarioId:
                                configuracionProvider.configuracion!.usuarioId,
                            notificacionesActivas: configuracionProvider
                                .configuracion!.notificacionesActivas,
                            tema: value!,
                          );
                          configuracionProvider
                              .updateConfiguracion(configuracion);
                        },
                        items: ['claro', 'oscuro'].map((tema) {
                          return DropdownMenuItem<String>(
                            value: tema,
                            child: Text(tema),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await configuracionProvider.fetchConfiguracion(usuarioId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

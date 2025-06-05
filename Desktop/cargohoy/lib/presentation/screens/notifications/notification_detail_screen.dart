import 'package:cargohoy/data/models/notificacion_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notificacion_provider.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificacionModel notificacion;

  const NotificationDetailScreen({super.key, required this.notificacion});

  @override
  Widget build(BuildContext context) {
    final notificacionProvider = Provider.of<NotificacionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Notificación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mensaje: ${notificacion.mensaje}',
                style: const TextStyle(fontSize: 18)),
            Text('Fecha: ${notificacion.fecha}',
                style: const TextStyle(fontSize: 18)),
            Text('Estado: ${notificacion.estado}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            if (notificacion.estado != 'leída')
              ElevatedButton(
                onPressed: () async {
                  await notificacionProvider.markAsRead(notificacion.id);
                  if (notificacionProvider.errorMessage.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(notificacionProvider.errorMessage)),
                    );
                  }
                },
                child: const Text('Marcar como Leída'),
              ),
          ],
        ),
      ),
    );
  }
}

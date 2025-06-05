import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notificacion_provider.dart';
import 'notification_detail_screen.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificacionProvider = Provider.of<NotificacionProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: notificacionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notificacionProvider.notificaciones.length,
              itemBuilder: (context, index) {
                final notificacion = notificacionProvider.notificaciones[index];
                return ListTile(
                  title: Text(notificacion.mensaje),
                  subtitle: Text(notificacion.fecha.toString()),
                  trailing: notificacion.estado == 'leída'
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.markunread, color: Colors.orange),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailScreen(
                            notificacion: notificacion),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await notificacionProvider.fetchNotificaciones(usuarioId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

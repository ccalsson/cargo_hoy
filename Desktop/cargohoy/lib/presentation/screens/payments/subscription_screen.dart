import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/suscripcion_provider.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suscripcionProvider = Provider.of<SuscripcionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Suscripciones')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await suscripcionProvider.createSubscription('básica');
                if (suscripcionProvider.errorMessage.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Suscripción creada exitosamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(suscripcionProvider.errorMessage)),
                  );
                }
              },
              child: const Text('Suscribirse al Plan Básico'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await suscripcionProvider.cancelSubscription('subscriptionId');
                if (suscripcionProvider.errorMessage.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Suscripción cancelada exitosamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(suscripcionProvider.errorMessage)),
                  );
                }
              },
              child: const Text('Cancelar Suscripción'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pago_provider.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pagoProvider = Provider.of<PagoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Pagos')),
      body: pagoProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pagoProvider.pagos.length,
              itemBuilder: (context, index) {
                final pago = pagoProvider.pagos[index];
                return ListTile(
                  title: Text('\$${pago.monto}'),
                  subtitle: Text(pago.descripcion),
                  trailing: Text(pago.estado),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pago_provider.dart';

class PaymentScreen extends StatelessWidget {
  final _montoController = TextEditingController();
  final _descripcionController = TextEditingController();

  PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pagoProvider = Provider.of<PagoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Procesar Pago')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _montoController,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 20),
            if (pagoProvider.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  final monto = double.parse(_montoController.text);
                  final descripcion = _descripcionController.text;
                  await pagoProvider.createPayment(monto, 'usd', descripcion);
                  if (pagoProvider.errorMessage.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(pagoProvider.errorMessage)),
                    );
                  }
                },
                child: const Text('Pagar'),
              ),
          ],
        ),
      ),
    );
  }
}

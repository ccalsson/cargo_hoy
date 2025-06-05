import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/soporte_provider.dart';

class SoporteScreen extends StatelessWidget {
  final _mensajeController = TextEditingController();

  SoporteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final soporteProvider = Provider.of<SoporteProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Soporte y Ayuda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _mensajeController,
              decoration: const InputDecoration(labelText: 'Mensaje'),
            ),
            const SizedBox(height: 20),
            if (soporteProvider.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  final mensaje = _mensajeController.text;
                  await soporteProvider.enviarSoporte(usuarioId, mensaje);
                  if (soporteProvider.errorMessage.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(soporteProvider.errorMessage)),
                    );
                  }
                },
                child: const Text('Enviar Solicitud'),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:cargohoy/presentation/providers/carga_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/carga_model.dart';

class CargaCreateScreen extends StatefulWidget {
  const CargaCreateScreen({super.key});

  @override
  CargaCreateScreenState createState() => CargaCreateScreenState();
}

class CargaCreateScreenState extends State<CargaCreateScreen> {
  final TextEditingController _tipoCargaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _dimensionesController = TextEditingController();
  final TextEditingController _origenController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cargaProvider = Provider.of<CargaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Carga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tipoCargaController,
              decoration: const InputDecoration(labelText: 'Tipo de Carga'),
            ),
            TextField(
              controller: _pesoController,
              decoration: const InputDecoration(labelText: 'Peso'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dimensionesController,
              decoration: const InputDecoration(labelText: 'Dimensiones'),
            ),
            TextField(
              controller: _origenController,
              decoration: const InputDecoration(labelText: 'Origen'),
            ),
            TextField(
              controller: _destinoController,
              decoration: const InputDecoration(labelText: 'Destino'),
            ),
            const SizedBox(height: 20),
            if (cargaProvider.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  final carga = CargaModel(
                    id: '', // Se genera en el backend
                    tipoCarga: _tipoCargaController.text,
                    peso: double.parse(_pesoController.text),
                    dimensiones: _dimensionesController.text,
                    origen: _origenController.text,
                    destino: _destinoController.text,
                    fechaEntrega: DateTime.now(),
                    fechaRecogida: DateTime.now(),
                    tarifa: 0.0,
                    metodoPago: 'Transferencia',
                    seguro: {'activo': false, 'tipo': 'básico'},
                    restricciones: {'temperatura': 'normal', 'fragil': false},
                    empresaId: 'empresaId', // Reemplazar con ID real
                  );
                  await cargaProvider.createCarga(carga);
                  if (!context.mounted) return;
                  if (cargaProvider.errorMessage.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(cargaProvider.errorMessage)),
                    );
                  }
                },
                child: const Text('Crear Carga'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tipoCargaController.dispose();
    _pesoController.dispose();
    _dimensionesController.dispose();
    _origenController.dispose();
    _destinoController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/metrics_provider.dart';

class FuelControlScreen extends StatefulWidget {
  const FuelControlScreen({super.key});

  @override
  State<FuelControlScreen> createState() => _FuelControlScreenState();
}

class _FuelControlScreenState extends State<FuelControlScreen> {
  final _formKey = GlobalKey<FormState>();
  final _litersController = TextEditingController();
  final _priceController = TextEditingController();
  final _odometerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Combustible'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _litersController,
              decoration: const InputDecoration(
                labelText: 'Litros',
                suffixText: 'L',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa los litros';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio por litro',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el precio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _odometerController,
              decoration: const InputDecoration(
                labelText: 'Kilometraje',
                suffixText: 'km',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el kilometraje';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitFuelRecord,
              child: const Text('Registrar Consumo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitFuelRecord() async {
    if (_formKey.currentState!.validate()) {
      try {
        final metrics = MetricsModel(
          id: '', // Se generará en Firestore
          userId: 'CURRENT_USER_ID',
          distance: double.parse(_odometerController.text),
          fuelConsumption: double.parse(_litersController.text),
          earnings: 0, // Se calculará basado en la carga actual
          date: DateTime.now(),
        );

        await context.read<MetricsProvider>().addMetrics(metrics);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro de combustible guardado'),
            ),
          );
          _formKey.currentState!.reset();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _litersController.dispose();
    _priceController.dispose();
    _odometerController.dispose();
    super.dispose();
  }
} 
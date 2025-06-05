import 'package:flutter/material.dart';
import '../../services/anticipo_service.dart';
import '../../models/anticipo_model.dart';

class AnticipoScreen extends StatefulWidget {
  final String tripId;
  final double montoTotal;

  const AnticipoScreen({
    Key? key,
    required this.tripId,
    required this.montoTotal,
  }) : super(key: key);

  @override
  State<AnticipoScreen> createState() => _AnticipoScreenState();
}

class _AnticipoScreenState extends State<AnticipoScreen> {
  final AnticipoService _anticipoService = AnticipoService();
  int _selectedPlazo = 7; // Por defecto 7 días
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Anticipo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResumenCard(),
            const SizedBox(height: 24),
            _buildPlazoSelector(),
            const SizedBox(height: 24),
            _buildDetallesAnticipo(),
            const SizedBox(height: 24),
            _buildBotonSolicitar(),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del Viaje',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Monto Total: \$${widget.montoTotal.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlazoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seleccione el plazo de pago',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _selectedPlazo,
          items: [
            DropdownMenuItem(
              value: 7,
              child: const Text('7 días (3% comisión)'),
            ),
            DropdownMenuItem(
              value: 15,
              child: const Text('15 días (5% comisión)'),
            ),
            DropdownMenuItem(
              value: 30,
              child: const Text('30 días (10% comisión)'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedPlazo = value ?? 7;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDetallesAnticipo() {
    final comision = _anticipoService.calcularComision(_selectedPlazo);
    final montoComision = widget.montoTotal * comision;
    final montoNeto = widget.montoTotal - montoComision;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles del Anticipo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetalleRow(
                'Monto Total', '\$${widget.montoTotal.toStringAsFixed(2)}'),
            _buildDetalleRow(
                'Comisión (${(comision * 100).toStringAsFixed(0)}%)',
                '\$${montoComision.toStringAsFixed(2)}'),
            const Divider(),
            _buildDetalleRow(
              'Monto Neto a Recibir',
              '\$${montoNeto.toStringAsFixed(2)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalleRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonSolicitar() {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading ? null : _solicitarAnticipo,
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Solicitar Anticipo'),
      ),
    );
  }

  Future<void> _solicitarAnticipo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final comision = _anticipoService.calcularComision(_selectedPlazo);

      await _anticipoService.createAnticipo(
        userId: 'CURRENT_USER_ID', // TODO: Obtener del AuthProvider
        tripId: widget.tripId,
        monto: widget.montoTotal,
        comision: comision,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anticipo solicitado exitosamente'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al solicitar anticipo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/metrics_provider.dart';

class PredictiveRouteScreen extends StatefulWidget {
  const PredictiveRouteScreen({super.key});

  @override
  State<PredictiveRouteScreen> createState() => _PredictiveRouteScreenState();
}

class _PredictiveRouteScreenState extends State<PredictiveRouteScreen> {
  MapboxMapController? _mapController;
  List<LatLng> _predictedRoute = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutas Predictivas'),
      ),
      body: Stack(
        children: [
          MapboxMap(
            accessToken: 'YOUR_MAPBOX_TOKEN',
            styleString: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 12.0,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildRouteInfo(),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    _loadPredictedRoute();
  }

  Future<void> _loadPredictedRoute() async {
    // Obtener datos históricos
    final metrics = await context.read<MetricsProvider>().fetchMetrics(
      userId: 'CURRENT_USER_ID',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
    );

    // Calcular ruta predictiva basada en datos históricos
    // Implementar lógica de predicción
    _predictedRoute = []; // Llenar con puntos de la ruta

    // Dibujar ruta en el mapa
    if (_mapController != null) {
      _mapController!.addLine(
        LineOptions(
          geometry: _predictedRoute,
          lineColor: '#FF0000',
          lineWidth: 3.0,
        ),
      );
    }
  }

  Widget _buildRouteInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ruta Predictiva',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Distancia estimada: ${_calculateDistance().toStringAsFixed(1)} km',
            ),
            Text(
              'Tiempo estimado: ${_calculateTime().toStringAsFixed(0)} min',
            ),
            Text(
              'Consumo estimado: ${_calculateFuel().toStringAsFixed(1)} L',
            ),
          ],
        ),
      ),
    );
  }

  double _calculateDistance() {
    // Implementar cálculo de distancia
    return 0.0;
  }

  double _calculateTime() {
    // Implementar cálculo de tiempo
    return 0.0;
  }

  double _calculateFuel() {
    // Implementar cálculo de combustible
    return 0.0;
  }
} 
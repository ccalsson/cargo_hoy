import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/carga_provider.dart';
import '../../core/theme/app_theme.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking en Vivo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(19.4326, -99.1332), // Ciudad de México
                zoom: 12,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),
          _buildActiveDeliveries(),
        ],
      ),
    );
  }

  Widget _buildActiveDeliveries() {
    return SizedBox(
      height: 200,
      child: Consumer<CargaProvider>(
        builder: (context, provider, child) {
          final activeCarga = provider.cargas
              .where((carga) => carga.estado == 'en_progreso')
              .toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: activeCarga.length,
            itemBuilder: (context, index) {
              final carga = activeCarga[index];
              return _buildActiveDeliveryCard(carga);
            },
          );
        },
      ),
    );
  }

  Widget _buildActiveDeliveryCard(CargaModel carga) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              carga.tipoCarga,
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text('${carga.origen} → ${carga.destino}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: AppTheme.primaryLightColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tiempo estimado:'),
                Text('2h 30min'), // Calcular tiempo real
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/load_provider.dart';
import '../../../../core/providers/location_provider.dart';
import '../../../../core/models/load_model.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  MapboxMapController? _mapController;
  final List<LoadModel> _nearbyLoads = [];

  @override
  void initState() {
    super.initState();
    _loadNearbyLoads();
  }

  Future<void> _loadNearbyLoads() async {
    final locationProvider = context.read<LocationProvider>();
    final loadProvider = context.read<LoadProvider>();

    if (locationProvider.currentPosition != null) {
      await loadProvider.fetchAvailableLoads(
        maxDistance: 50.0, // 50km
        location: {
          'latitude': locationProvider.currentPosition!.latitude,
          'longitude': locationProvider.currentPosition!.longitude,
        },
      );
    }
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    _addLoadMarkers();
  }

  void _addLoadMarkers() {
    if (_mapController == null) return;

    final loads = context.read<LoadProvider>().availableLoads;
    for (final load in loads) {
      _mapController!.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            load.origin['latitude'],
            load.origin['longitude'],
          ),
          iconImage: 'marker',
          iconSize: 1.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargas Disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Mostrar filtros
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MapboxMap(
            accessToken: 'YOUR_MAPBOX_TOKEN',
            styleString: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0), // Centrar en la ubicación actual
              zoom: 12.0,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildLoadList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadList() {
    return Consumer<LoadProvider>(
      builder: (context, loadProvider, child) {
        if (loadProvider.isLoading) {
          return const CircularProgressIndicator();
        }

        return Card(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: loadProvider.availableLoads.length,
            itemBuilder: (context, index) {
              final load = loadProvider.availableLoads[index];
              return ListTile(
                title: Text(load.title),
                subtitle: Text('\$${load.price.toStringAsFixed(2)}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/load-detail',
                      arguments: load,
                    );
                  },
                  child: const Text('Ver Detalles'),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 
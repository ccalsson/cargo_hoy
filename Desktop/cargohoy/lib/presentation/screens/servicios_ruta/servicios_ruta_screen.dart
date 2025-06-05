import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/servicios_ruta_service.dart';

class ServiciosRutaScreen extends StatefulWidget {
  const ServiciosRutaScreen({super.key});

  @override
  _ServiciosRutaScreenState createState() => _ServiciosRutaScreenState();
}

class _ServiciosRutaScreenState extends State<ServiciosRutaScreen> {
  final ServiciosRutaService _service = ServiciosRutaService();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  String _selectedTipoServicio = 'auxilio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios en Ruta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: _mostrarDialogoEmergencia,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltros(),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(19.4326, -99.1332),
                    zoom: 12,
                  ),
                  markers: _markers,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
                _buildListaServicios(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Auxilio'),
            selected: _selectedTipoServicio == 'auxilio',
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedTipoServicio = 'auxilio');
                _buscarServicios();
              }
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Gomería'),
            selected: _selectedTipoServicio == 'gomeria',
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedTipoServicio = 'gomeria');
                _buscarServicios();
              }
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Combustible'),
            selected: _selectedTipoServicio == 'combustible',
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedTipoServicio = 'combustible');
                _buscarServicios();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListaServicios() {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 10, // Reemplazar con lista real
            itemBuilder: (context, index) {
              return _buildServicioCard();
            },
          ),
        );
      },
    );
  }

  Widget _buildServicioCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.build),
        title: const Text('Nombre del Servicio'),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Distancia: 5km'),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber),
                Text('4.5'),
              ],
            ),
          ],
        ),
        trailing: TextButton(
          child: const Text('Contactar'),
          onPressed: () {
            // Implementar llamada o solicitud
          },
        ),
      ),
    );
  }

  void _mostrarDialogoEmergencia() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Solicitar Auxilio de Emergencia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Descripción de la emergencia',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implementar solicitud de emergencia
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Enviar Ubicación Actual'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buscarServicios() async {
    // Implementar búsqueda de servicios
  }
}

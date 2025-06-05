import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoadSearchScreen extends StatelessWidget {
  const LoadSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Cargas')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mapa interactivo para selección de rutas
            const SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(-34.6037, -58.3816), // Buenos Aires coordinates
                  zoom: 11,
                ),
              ),
            ),

            // Filtros avanzados
            ExpansionTile(
              title: const Text('Filtros Avanzados'),
              children: [
                FilterChip(label: const Text('Urgente'), onSelected: (_) {}),
                FilterChip(label: const Text('Alto valor'), onSelected: (_) {}),
                FilterChip(
                    label: const Text('Refrigerado'), onSelected: (_) {}),
                // ... más filtros
              ],
            ),

            // Calendario de disponibilidad
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              onDateChanged: (_) {},
            ),

            // Rango de precios
            RangeSlider(
              values: const RangeValues(0, 1000),
              min: 0,
              max: 10000,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

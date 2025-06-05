import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InteractiveMap extends StatelessWidget {
  final Function(LatLng) onLocationSelected;

  const InteractiveMap({super.key, required this.onLocationSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(19.4326, -99.1332), // Ciudad de México
            zoom: 11,
          ),
          onTap: onLocationSelected,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}

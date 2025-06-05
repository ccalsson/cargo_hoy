import 'package:location/location.dart';

class TrackingService {
  final Location location = Location();
  Stream<LocationData>? locationStream;

  Future<void> startTracking() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }

    locationStream = location.onLocationChanged;
  }

  Future<void> updateLocation(String cargaId, LocationData locationData) async {
    // Actualizar ubicación en la base de datos
  }
} 
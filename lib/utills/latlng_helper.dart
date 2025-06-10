import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng? parseLatLng(Map<String, dynamic> data) {
  final lat = double.tryParse(data['lat'] ?? '') ?? double.tryParse(data['latitude'] ?? '');
  final lng = double.tryParse(data['lng'] ?? '') ?? double.tryParse(data['longitude'] ?? '');
  if (lat == null || lng == null) return null;
  return LatLng(lat, lng);
}

LatLngBounds createLatLngBounds(List<LatLng> latLngs) {
  final southwestLat = latLngs.map((l) => l.latitude).reduce((a, b) => a < b ? a : b);
  final southwestLng = latLngs.map((l) => l.longitude).reduce((a, b) => a < b ? a : b);
  final northeastLat = latLngs.map((l) => l.latitude).reduce((a, b) => a > b ? a : b);
  final northeastLng = latLngs.map((l) => l.longitude).reduce((a, b) => a > b ? a : b);
  return LatLngBounds(
    southwest: LatLng(southwestLat, southwestLng),
    northeast: LatLng(northeastLat, northeastLng),
  );
}

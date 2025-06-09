import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng? parseLatLng(Map<String, dynamic> data) {
  final lat = double.tryParse(data['lat'] ?? '') ?? double.tryParse(data['latitude'] ?? '');
  final lng = double.tryParse(data['lng'] ?? '') ?? double.tryParse(data['longitude'] ?? '');
  if (lat == null || lng == null) return null;
  return LatLng(lat, lng);
}

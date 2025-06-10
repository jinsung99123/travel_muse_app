import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/utills/latlng_helper.dart';

Set<Marker> createMarkers({
  required List<Map<String, dynamic>> places,
  required Function(Map<String, dynamic>) onTap,
  required Function(int) onPageChanged,
  required Function(int) animateToPage,
}) {
  return places.asMap().entries.map((entry) {
    final index = entry.key;
    final place = entry.value;
    final LatLng? latLng = parseLatLng(place);
    if (latLng == null) return null;

    return Marker(
      markerId: MarkerId(place['id'] ?? '${latLng.latitude}_${latLng.longitude}_${place['title']}'),
      position: latLng,
      infoWindow: InfoWindow(title: '${index + 1}. ${place['title'] ?? ''}'),
      onTap: () {
        onTap(place);
        final idx = places.indexWhere(
          (p) =>
              (p['id'] != null && p['id'] == place['id']) ||
              (p['title'] == place['title'] &&
                  p['lat'] == place['lat'] &&
                  p['lng'] == place['lng']),
        );
        if (idx != -1) {
          animateToPage(idx);
          onPageChanged(idx);
        }
      },
    );
  }).whereType<Marker>().toSet();
}

String getDisplayDayTab(String key) {
  final num = int.tryParse(key.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  return 'Day ${num + 1}';
}

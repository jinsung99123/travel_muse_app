import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/utills/latlng_helper.dart';

/// 여행 장소 리스트를 기반으로 Google Maps에 표시할 마커들을 생성합니다.
Set<Marker> createMarkers({
  required List<Map<String, dynamic>> places,
    required BitmapDescriptor icon,
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
      icon: icon, 
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
/// Day 키 값을 기반으로 탭 라벨 문자열을 생성합니다.
String getDisplayDayTab(String key) {
  final num = int.tryParse(key.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  return 'Day ${num + 1}';
}

import 'dart:math';

/// 위경도 기반 거리 계산
double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const earthRadius = 6371.0; // 단위: km
  final dLat = _toRadians(lat2 - lat1);
  final dLng = _toRadians(lng2 - lng1);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _toRadians(double degree) => degree * pi / 180;

/// 중심 좌표(평균값) 계산
Map<String, double> getCenterCoordinate(List<Map<String, String>> places) {
  final avgLat =
      places.map((p) => double.parse(p['lat']!)).reduce((a, b) => a + b) /
      places.length;
  final avgLng =
      places.map((p) => double.parse(p['lng']!)).reduce((a, b) => a + b) /
      places.length;
  return {'lat': avgLat, 'lng': avgLng};
}

/// 가까운 거리순 정렬
List<Map<String, String>> sortPlacesByDistance(
  List<Map<String, String>> places,
) {
  final center = getCenterCoordinate(places);

  places.sort((a, b) {
    final distA = calculateDistance(
      center['lat']!,
      center['lng']!,
      double.parse(a['lat']!),
      double.parse(a['lng']!),
    );
    final distB = calculateDistance(
      center['lat']!,
      center['lng']!,
      double.parse(b['lat']!),
      double.parse(b['lng']!),
    );
    return distA.compareTo(distB);
  });

  return places;
}

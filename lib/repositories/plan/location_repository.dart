import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationRepository {
  DateTime? _cachedAt;
  LatLng? _cached;

  /// 현재 위치 (5분 캐시)
  Future<LatLng> getCurrent() async {
    // 캐시 유효하면 바로 반환
    if (_cached != null &&
        DateTime.now().difference(_cachedAt!) < const Duration(minutes: 5)) {
      return _cached!;
    }

    // 권한 체크 요청
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        // 거부 시 서울시청 좌표 기본값
        return const LatLng(37.5665, 126.9780);
      }
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _cached = LatLng(pos.latitude, pos.longitude);
    _cachedAt = DateTime.now();
    return _cached!;
  }
}

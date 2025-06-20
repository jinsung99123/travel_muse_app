import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/plan/map_state.dart';
import 'package:travel_muse_app/repositories/plan/map_repository.dart';
import 'package:travel_muse_app/utills/latlng_helper.dart';
import 'package:travel_muse_app/utills/map_utils.dart';
import 'package:travel_muse_app/utills/marker_helper.dart';

class MapViewModel extends StateNotifier<MapState> {
  MapViewModel(this._repository) : super(MapState(dayPlaces: {})) {
    _loadAssets();
  }

  final MapRepository _repository;

  late final BitmapDescriptor _pinIcon;
  bool _iconReady = false;

  /// 커스텀 마커 아이콘 비트맵을 비동기로 로드합니다.
  Future<void> _loadAssets() async {
    _pinIcon = await bitmapDescriptorFromSvgAsset('assets/icons/map_pin.svg');
    _iconReady = true;
    state = state.copyWith();
  }

  BitmapDescriptor get _currentIcon =>
      _iconReady ? _pinIcon : BitmapDescriptor.defaultMarker;

  /// 해당 플랜의 날짜별 장소 경로 데이터를 Firestore에서 불러옵니다.
  Future<void> loadPlanAndRoute(String planId, TickerProvider vsync) async {
    try {
      final loadedDayPlaces = await _repository.getRouteByDay(planId);
      state = state.copyWith(dayPlaces: loadedDayPlaces);

      if (loadedDayPlaces.isNotEmpty) {
        final firstDay = loadedDayPlaces.entries.first;
        if (firstDay.value.isNotEmpty) {
          state = state.copyWith(selectedPlace: firstDay.value.first);
        }
      }
    } catch (e) {
      debugPrint('❌ loadPlanAndRoute 실패: $e');
    }
  }

  /// 장소 선택 상태 업데이트
  void selectPlace(Map<String, dynamic> place) =>
      state = state.copyWith(selectedPlace: place);

  /// 선택된 장소 초기화
  void clearSelectedPlace() => state = state.copyWith(selectedPlace: null);

  /// 각 날짜 키에 따른 PageController 저장소
  final Map<String, PageController> _pageControllers = {};

  /// 특정 날짜 키에 해당하는 PageController 반환 또는 생성
  PageController getPageController(String dayKey) => _pageControllers
      .putIfAbsent(dayKey, () => PageController(viewportFraction: 1));

  /// 모든 PageController 해제
  void disposeControllers() {
    for (final ctrl in _pageControllers.values) {
      ctrl.dispose();
    }
  }

  /// 장소 리스트로부터 LatLng 좌표 리스트 추출
  List<LatLng> extractLatLngs(List<Map<String, dynamic>> places) =>
      places.map(parseLatLng).whereType<LatLng>().toList();

  /// 주어진 좌표 리스트로 LatLngBounds 계산
  LatLngBounds createLatLngBounds(List<LatLng> latLngs) {
    final swLat = latLngs
        .map((e) => e.latitude)
        .reduce((a, b) => a < b ? a : b);
    final swLng = latLngs
        .map((e) => e.longitude)
        .reduce((a, b) => a < b ? a : b);
    final neLat = latLngs
        .map((e) => e.latitude)
        .reduce((a, b) => a > b ? a : b);
    final neLng = latLngs
        .map((e) => e.longitude)
        .reduce((a, b) => a > b ? a : b);
    return LatLngBounds(
      southwest: LatLng(swLat, swLng),
      northeast: LatLng(neLat, neLng),
    );
  }

  /// 첫 장소의 좌표 반환 (없으면 null)
  LatLng? getInitialLatLng(List<Map<String, dynamic>> places) =>
      places.isEmpty ? null : parseLatLng(places.first);

  /// 주어진 장소 리스트에 맞춰 카메라를 이동시킵니다.
  void moveCameraToFitAll(
    GoogleMapController? mapController,
    List<Map<String, dynamic>> places,
  ) {
    final latLngs = extractLatLngs(places);

    if (latLngs.length >= 2) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(createLatLngBounds(latLngs), 100),
      );
    } else if (latLngs.isNotEmpty) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLngs.first, 14),
      );
    }
  }

  /// 지도에 표시할 마커 리스트를 반환합니다.
  Set<Marker> getMarkers({
    required List<Map<String, dynamic>> places,
    required String selectedDayKey,
    required Function(Map<String, dynamic>) onTap,
    required Function(int) onPageChanged,
  }) {
    return createMarkers(
      places: places,
      icon: _currentIcon,
      onTap: onTap,
      onPageChanged: onPageChanged,
      animateToPage:
          (idx) => getPageController(selectedDayKey).animateToPage(
            idx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
    );
  }

  /// 전체 날짜의 모든 장소 리스트를 반환합니다.
  List<Map<String, dynamic>> getAllPlaces() {
    return state.dayPlaces.values.expand((list) => list).toList();
  }

  ///전체 위경도 반환
  List<LatLng> getAllLatLngs() {
    return extractLatLngs(getAllPlaces());
  }

//전체 마커 반환
  Set<Marker> getAllMarkers({
    required Function(Map<String, dynamic>) onTap,
    required Function(int) onPageChanged,
  }) {
    return createMarkers(
      places: getAllPlaces(),
      icon: _currentIcon,
      onTap: onTap,
      onPageChanged: onPageChanged,
      animateToPage: (idx) {
        // 전체 탭은 Carousel 안 보이게 할 수도 있음
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/map_state.dart';
import 'package:travel_muse_app/repositories/map_repository.dart';
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

  Future<void> _loadAssets() async {
    _pinIcon = await bitmapDescriptorFromSvgAsset(
      'assets/icons/map_pin.svg',                   
    );
    _iconReady = true;
    state = state.copyWith();                             
  }

  BitmapDescriptor get _currentIcon =>
      _iconReady ? _pinIcon : BitmapDescriptor.defaultMarker;

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

  void selectPlace(Map<String, dynamic> place) =>
      state = state.copyWith(selectedPlace: place);

  void clearSelectedPlace() =>
      state = state.copyWith(selectedPlace: null);

  final Map<String, PageController> _pageControllers = {};

  PageController getPageController(String dayKey) =>
      _pageControllers.putIfAbsent(
        dayKey,
        () => PageController(viewportFraction: 1),
      );

  void disposeControllers() {
    for (final ctrl in _pageControllers.values) {
      ctrl.dispose();
    }
  }

  List<LatLng> extractLatLngs(List<Map<String, dynamic>> places) =>
      places.map(parseLatLng).whereType<LatLng>().toList();

  LatLngBounds createLatLngBounds(List<LatLng> latLngs) {
    final swLat = latLngs.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    final swLng = latLngs.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
    final neLat = latLngs.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    final neLng = latLngs.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);
    return LatLngBounds(
      southwest: LatLng(swLat, swLng),
      northeast: LatLng(neLat, neLng),
    );
  }

  LatLng? getInitialLatLng(List<Map<String, dynamic>> places) =>
      places.isEmpty ? null : parseLatLng(places.first);

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
      animateToPage: (idx) => getPageController(selectedDayKey).animateToPage(
        idx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }
}

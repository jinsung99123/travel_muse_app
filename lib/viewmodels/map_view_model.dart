import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/map_state.dart';
import 'package:travel_muse_app/repositories/map_repository.dart';

class MapViewModel extends StateNotifier<MapState> {
  MapViewModel(this._repository) : super(MapState(dayPlaces: {}));

  final MapRepository _repository;

  TabController? tabController;
  final Map<String, PageController> pageControllers = {};

  Future<void> loadPlanAndRoute(String planId, TickerProvider vsync) async {
    try {
      final planData = await _repository.getPlan(planId);
      if (planData == null) return;

      final title = planData['title'] as String? ?? '';
      final date = planData['date'] as String? ?? '';

      final loadedDayPlaces = await _repository.getRouteByDay(planId);

      state = state.copyWith(
        dayPlaces: loadedDayPlaces,
        title: title,
        date: date,
      );

      if (loadedDayPlaces.isNotEmpty) {
        final firstDay = loadedDayPlaces.entries.first;
        if (firstDay.value.isNotEmpty) {
          state = state.copyWith(selectedPlace: firstDay.value.first);
        }
      }

      _initTabController(loadedDayPlaces.keys.toList(), vsync);
    } catch (e) {
      print('❌ loadPlanAndRoute 실패: $e');
    }
  }

  void selectPlace(Map<String, String> place) {
    state = state.copyWith(selectedPlace: place);
  }

  void clearSelectedPlace() {
    state = state.copyWith(selectedPlace: null);
  }

  void _initTabController(List<String> dayKeys, TickerProvider vsync) {
    tabController?.dispose();
    tabController = TabController(length: dayKeys.length, vsync: vsync);
  }

  PageController getPageController(String dayKey) {
    return pageControllers.putIfAbsent(
      dayKey,
      () => PageController(viewportFraction: 0.85),
    );
  }

  List<LatLng> extractLatLngs(List<Map<String, dynamic>> places) {
    return places.map((p) {
      final lat = double.tryParse(p['lat'] ?? '') ?? double.tryParse(p['latitude'] ?? '');
      final lng = double.tryParse(p['lng'] ?? '') ?? double.tryParse(p['longitude'] ?? '');
      if (lat == null || lng == null) return null;
      return LatLng(lat, lng);
    }).whereType<LatLng>().toList();
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

  LatLng? getInitialLatLng(List<Map<String, dynamic>> places) {
    if (places.isEmpty) return null;
    final first = places.first;
    final lat = double.tryParse(first['lat'] ?? '') ?? double.tryParse(first['latitude'] ?? '');
    final lng = double.tryParse(first['lng'] ?? '') ?? double.tryParse(first['longitude'] ?? '');
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
    return null;
  }

  void disposeControllers() {
    tabController?.dispose();
    for (final controller in pageControllers.values) {
      controller.dispose();
    }
  }
}

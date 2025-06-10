import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/map_state.dart';
import 'package:travel_muse_app/models/plans.dart';
import 'package:travel_muse_app/repositories/map_repository.dart';
import 'package:travel_muse_app/utills/latlng_helper.dart';
import 'package:travel_muse_app/utills/map_utils.dart';

class MapViewModel extends StateNotifier<MapState> {
  MapViewModel(this._repository) : super(MapState(dayPlaces: {}));

  final MapRepository _repository;

  final Map<String, PageController> pageControllers = {};
  Plans? planInfo;

  Future<void> loadPlanAndRoute(String planId, TickerProvider vsync) async {
    try {
      final planData = await _repository.getPlan(planId);
      if (planData == null) return;

      planInfo = Plans.fromJson(planId, planData);

      final title = planInfo?.title ?? '';
      final date = _formatDateRange(planInfo!.startDate, planInfo!.endDate);

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
    } catch (e) {
      print('❌ loadPlanAndRoute 실패: $e');
    }
  }

  String _formatDateRange(DateTime start, DateTime end) {
    String format(DateTime date) =>
        '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    return '${format(start)} ~ ${format(end)}';
  }

  void selectPlace(Map<String,dynamic> place) {
    state = state.copyWith(selectedPlace: place);
  }

  void clearSelectedPlace() {
    state = state.copyWith(selectedPlace: null);
  }

  PageController getPageController(String dayKey) {
    return pageControllers.putIfAbsent(
      dayKey,
      () => PageController(viewportFraction: 0.85),
    );
  }

  List<LatLng> extractLatLngs(List<Map<String, dynamic>> places) {
    return places.map((p) => parseLatLng(p)).whereType<LatLng>().toList();
  }

  LatLngBounds createLatLngBounds(List<LatLng> latLngs) {
    final southwestLat = latLngs
        .map((l) => l.latitude)
        .reduce((a, b) => a < b ? a : b);
    final southwestLng = latLngs
        .map((l) => l.longitude)
        .reduce((a, b) => a < b ? a : b);
    final northeastLat = latLngs
        .map((l) => l.latitude)
        .reduce((a, b) => a > b ? a : b);
    final northeastLng = latLngs
        .map((l) => l.longitude)
        .reduce((a, b) => a > b ? a : b);
    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLng),
      northeast: LatLng(northeastLat, northeastLng),
    );
  }

  LatLng? getInitialLatLng(List<Map<String, dynamic>> places) {
    if (places.isEmpty) return null;
    return parseLatLng(places.first);
  }

  void disposeControllers() {
    for (final controller in pageControllers.values) {
      controller.dispose();
    }
  }

  void moveCameraToFitAll(
    GoogleMapController? mapController,
    List<Map<String, dynamic>> places,
  ) {
    final latLngs = extractLatLngs(places);

    if (latLngs.length >= 2) {
      final bounds = createLatLngBounds(latLngs);
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
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
      onTap: onTap,
      onPageChanged: onPageChanged,
      animateToPage: (idx) {
        getPageController(selectedDayKey).animateToPage(
          idx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plan/place.dart';
import 'package:travel_muse_app/providers/plan/schedule/map_provider.dart';
import 'package:travel_muse_app/services/plan/nearby_place_service.dart';
import 'package:travel_muse_app/services/plan/place_search_service.dart';

class SearchViewModel extends StateNotifier<List<Map<String, String>>> {
  SearchViewModel(this.ref, this._placeService, this._nearbyService)
    : super([]);
  final Ref ref;
  final PlaceSearchService _placeService;
  final NearbyPlaceService _nearbyService;

  static const defaultImage =
      'https://cdn.pixabay.com/photo/2017/06/24/04/37/cloud-2436676_1280.jpg';

  /// 키워드 검색 (선택적으로 지역 필터 적용)
  Future<void> search(String query, {String? region}) async {
    try {
      final places = await _fetchPlaces(query: query, region: region);
      final results = await _mapPlacesToViewData(places);
      state = results;

      // 지도 마커 반영
      ref
          .read(mapViewModelProvider.notifier)
          .setDayPlacesForSelectMode(
            results.map((e) => e as Map<String, dynamic>).toList(),
          );
    } catch (_) {
      state = [];
    }
  }

  ///추천 명소 로드 (지역 기반)
  Future<void> loadRecommendedByRegion(
    String region, [
    String? categoryCode,
  ]) async {
    final latLng = await _placeService.getLatLngFromRegion(region);
    if (latLng == null) return;

    List<Place> places;

    if (categoryCode == null) {
      final spots = await _nearbyService.fetchSpotsByCategory(
      loc: latLng,
      categoryCode: 'AT4',
    );
      final foods = await _nearbyService.fetchFoods(loc: latLng);
      places = [...spots, ...foods];
    } else {
      places = await _nearbyService.fetchSpotsByCategory(
        loc: latLng,
        categoryCode: categoryCode,
      );
    }

    final result = await _mapPlacesToViewData(places);
    state = result;
  }

  ///지역 기반 또는 전국 검색 처리
  Future<List<Place>> _fetchPlaces({
    required String query,
    String? region,
  }) async {
    if (region != null) {
      final latLng = await _placeService.getLatLngFromRegion(region);
      if (latLng != null) {
        return await _placeService.searchByKeyword(
          query: query,
          lat: latLng.latitude,
          lng: latLng.longitude,
        );
      }
    }
    return await _placeService.search(query);
  }

  /// Place -> Map<String, String> 형태로 변환
  Future<List<Map<String, String>>> _mapPlacesToViewData(
    List<Place> places,
  ) async {
    return Future.wait(
      places.map((p) async {
        final thumb = await _placeService.getThumbnailCached(p.name);
        return {
          'title': p.name,
          'subtitle': '${p.city} ${p.district} • ${p.category}',
          'address': p.address,
          'image': thumb ?? defaultImage,
          'lat': p.latitude.toString(),
          'lng': p.longitude.toString(),
        };
      }),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/place.dart';
import 'package:travel_muse_app/services/nearby_place_service.dart';
import 'package:travel_muse_app/services/place_search_service.dart';

class SearchViewModel extends StateNotifier<List<Map<String, String>>> {
  SearchViewModel(this._placeService, this._nearbyService) : super([]);

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
    } catch (_) {
      state = [];
    }
  }

  ///추천 명소 맛집 로드 (지역 기반)
  Future<void> loadRecommendedByRegion(String region) async {
    final latLng = await _placeService.getLatLngFromRegion(region);
    if (latLng == null) return;

    final spots = await _nearbyService.fetchSpots(loc: latLng);
    final foods = await _nearbyService.fetchFoods(loc: latLng);
    final combined = await _mapPlacesToViewData([...spots, ...foods]);

    state = combined;
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
      List<Place> places) async {
    return Future.wait(places.map((p) async {
      final thumb = await _placeService.getThumbnailCached(p.name);
      return {
        'title': p.name,
        'subtitle': '${p.city} ${p.district} • ${p.category}',
        'image': thumb ?? defaultImage,
        'lat': p.latitude.toString(),
        'lng': p.longitude.toString(),
      };
    }));
  }
}

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/plan/place.dart';
import 'package:travel_muse_app/services/plan/place_search_service.dart';

///  - 키워드 + 위치 검색
class NearbyPlaceService {
  NearbyPlaceService(this.base);

  final PlaceSearchService base;

  //맛집(음식점)
  /// 내 위치 [loc] 기준 맛집(카테고리 FD6)를 거리순으로 가져옵니다.
  Future<List<Place>> fetchFoods({
    required LatLng loc,
    int radius = 10000,
    int page = 1,
    int size = 15,
  }) => base.searchByCategory(
    categoryCode: 'FD6',
    lat: loc.latitude,
    lng: loc.longitude,
    radius: radius,
    page: page,
    size: size,
  );

  //카테고리 코드 기반 검색
  Future<List<Place>> fetchSpotsByCategory({
    required LatLng loc,
    required String categoryCode,
    int radius = 10000,
    int page = 1,
    int size = 15,
  }) => base.searchByCategory(
    categoryCode: categoryCode,
    lat: loc.latitude,
    lng: loc.longitude,
    radius: radius,
    page: page,
    size: size,
  );
}

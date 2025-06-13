import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/place.dart';
import 'package:travel_muse_app/services/place_search_service.dart';

///  - 명소(AT4) · 맛집(FD6) 등 카테고리 전용 호출
///  - 키워드 + 위치 검색
class NearbyPlaceService {
  NearbyPlaceService(this.base);

  final PlaceSearchService base;

  //명소(관광)
  /// 내 위치 [loc] 기준 관광명소(카테고리 AT4)를 거리순으로 가져옵니다.
  /// [radius] : 검색 반경(m) – 10000m(10km) 기본  
  Future<List<Place>> fetchSpots({
    required LatLng loc,
    int radius = 10000,
    int page = 1,
    int size = 15,
  }) =>
      base.searchByCategory(
        categoryCode: 'AT4',
        lat: loc.latitude,
        lng: loc.longitude,
        radius: radius,
        page: page,
        size: size,
      );

  //맛집(음식점)
  /// 내 위치 [loc] 기준 맛집(카테고리 FD6)를 거리순으로 가져옵니다.
  Future<List<Place>> fetchFoods({
    required LatLng loc,
    int radius = 10000,
    int page = 1,
    int size = 15,
  }) =>
      base.searchByCategory(
        categoryCode: 'FD6',
        lat: loc.latitude,
        lng: loc.longitude,
        radius: radius,
        page: page,
        size: size,
      );

  //키워드 + 위치 검색
  /// 검색어 [query] 를 내 위치 [loc] 반경 안에서 검색합니다.
  Future<List<Place>> searchKeywordNearby({
    required String query,
    required LatLng loc,
    int radius = 3000,
    int page = 1,
    int size = 15,
  }) =>
      base.searchByKeyword(
        query: query,
        lat: loc.latitude,
        lng: loc.longitude,
        radius: radius,
        page: page,
        size: size,
      );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/services/plan/place_search_service.dart';

/// 키워드 기반 장소 검색 기능을 제공하는 Provider.
final placeSearchServiceProvider = Provider<PlaceSearchService>((ref) {
  return PlaceSearchService();
});

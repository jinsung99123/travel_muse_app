import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/plan/schedule/nearby_place_service_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/place_search_service_provider.dart';
import 'package:travel_muse_app/viewmodels/plan/search_view_model.dart';


/// 장소 검색 기능을 담당하는 ViewModel Provider
/// 검색 키워드 기반 장소 검색과 현재 위치 기반 근처 장소 검색을 모두 처리합니다.
final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, List<Map<String, String>>>((ref) {
      final placeSvc = ref.watch(placeSearchServiceProvider);
      final nearbySvc = ref.watch(nearbyPlaceServiceProvider);
      return SearchViewModel(placeSvc, nearbySvc);
    });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/plan/schedule/place_search_service_provider.dart';
import 'package:travel_muse_app/services/plan/nearby_place_service.dart';

/// 현재 장소를 기준으로 주변 장소를 탐색하는 서비스 Provider.
final nearbyPlaceServiceProvider = Provider<NearbyPlaceService>((ref) {
  final baseSvc = ref.watch(placeSearchServiceProvider);
  return NearbyPlaceService(baseSvc);
});

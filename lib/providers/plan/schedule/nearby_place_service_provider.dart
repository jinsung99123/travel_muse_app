import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/plan/schedule/place_search_service_provider.dart';
import 'package:travel_muse_app/services/plan/nearby_place_service.dart';

final nearbyPlaceServiceProvider = Provider<NearbyPlaceService>((ref) {
  final baseSvc = ref.watch(placeSearchServiceProvider);
  return NearbyPlaceService(baseSvc);
});

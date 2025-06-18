import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/plan/schedule/nearby_place_service_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/place_search_service_provider.dart';
import 'package:travel_muse_app/viewmodels/plan/search_view_model.dart';

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, List<Map<String, String>>>((ref) {
      final placeSvc = ref.watch(placeSearchServiceProvider);
      final nearbySvc = ref.watch(nearbyPlaceServiceProvider);
      return SearchViewModel(placeSvc, nearbySvc);
    });

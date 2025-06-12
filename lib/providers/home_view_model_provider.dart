import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/home_state.dart';
import 'package:travel_muse_app/providers/neardy_place_service_provider.dart';
import 'package:travel_muse_app/providers/place_search_service_provider.dart';
import 'package:travel_muse_app/viewmodels/home_view_model.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<HomeState>>((ref) {
  final nearbySvc = ref.watch(nearbyPlaceServiceProvider);
  final placeSvc  = ref.watch(placeSearchServiceProvider);
  return HomeViewModel(ref, nearbySvc, placeSvc);
});


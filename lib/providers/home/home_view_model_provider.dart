import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/home/home_state.dart';
import 'package:travel_muse_app/providers/plan/schedule/nearby_place_service_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/place_search_service_provider.dart';
import 'package:travel_muse_app/viewmodels/home/home_view_model.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<HomeState>>((ref) {
      final nearbySvc = ref.watch(nearbyPlaceServiceProvider);
      final placeSvc = ref.watch(placeSearchServiceProvider);
      return HomeViewModel(ref, nearbySvc, placeSvc);
    });

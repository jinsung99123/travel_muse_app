import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plan/map_state.dart';
import 'package:travel_muse_app/repositories/plan/map_repository.dart';
import 'package:travel_muse_app/viewmodels/plan/map_view_model.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository();
});

final mapViewModelProvider =
    StateNotifierProvider.autoDispose<MapViewModel, MapState>(
      (ref) => MapViewModel(MapRepository()),
    );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/map_state.dart';
import 'package:travel_muse_app/repositories/map_repository.dart';
import 'package:travel_muse_app/viewmodels/map_view_model.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository();
});

final mapViewModelProvider =
    StateNotifierProvider<MapViewModel, MapState>((ref) {
  final repo = ref.watch(mapRepositoryProvider);
  return MapViewModel(repo);
});

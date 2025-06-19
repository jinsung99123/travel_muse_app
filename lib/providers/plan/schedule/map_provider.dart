import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plan/map_state.dart';
import 'package:travel_muse_app/repositories/plan/map_repository.dart';
import 'package:travel_muse_app/viewmodels/plan/map_view_model.dart';

/// Map 데이터를 처리하는 Repository를 제공하는 Provider.
final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository();
});

/// Map 화면의 상태를 관리하는 ViewModel Provider.
final mapViewModelProvider =
    StateNotifierProvider.autoDispose<MapViewModel, MapState>(
      (ref) => MapViewModel(MapRepository()),
    );

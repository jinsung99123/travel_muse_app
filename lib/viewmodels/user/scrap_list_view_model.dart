// scrap_list_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/repositories/home/scrap_repository.dart';

class ScrapListViewModel extends StateNotifier<AsyncValue<List<HomePlace>>> {
  ScrapListViewModel(this._repo) : super(const AsyncValue.loading()) {
    load();
  }

  final ScrapRepository _repo;

/// 북마크 리스트 불러오기
  Future<void> load() async {
    try {
      final data = await _repo.fetchScrappedPlaces();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

///북마크 삭제 리스트에서도 삭제
  Future<void> remove(HomePlace place) async {
  try {
    await _repo.deleteScrap(place.id); 

    final current = state.asData?.value ?? [];
    final updated = current.where((p) => p.id != place.id).toList();

    state = AsyncValue.data(updated);
  } catch (e, st) {
    state = AsyncValue.error(e, st);
  }
}

}

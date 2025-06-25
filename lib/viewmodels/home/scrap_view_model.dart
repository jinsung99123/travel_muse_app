import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/repositories/home/scrap_repository.dart';

class ScrapViewModel extends StateNotifier<Set<String>> {
  ScrapViewModel(this._repo) : super({});

  final ScrapRepository _repo;

  /// 특정 장소에 대해 스크랩 상태를 토글
  /// 이미 스크랩되어 있으면 삭제하고 그렇지 않으면 스크랩한다
  Future<void> toggleScrap(HomePlace place) async {
    final isScrapped = state.contains(place.id);

    if (isScrapped) {
      await _repo.deleteScrap(place.id);
      state = {...state}..remove(place.id);
    } else {
      await _repo.saveScrap(place);
      state = {...state}..add(place.id);
    }
  }

  /// 해당 장소 ID가 스크랩 상태인지 확인
  bool isScrapped(String placeId) => state.contains(placeId);
}

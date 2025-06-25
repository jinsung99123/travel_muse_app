import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/repositories/home/scrap_repository.dart';
import 'package:travel_muse_app/viewmodels/home/scrap_view_model.dart';
import 'package:travel_muse_app/viewmodels/user/scrap_list_view_model.dart';

/// 스크랩 관련 Firebase 통신을 담당
final scrapRepositoryProvider = Provider((ref) => ScrapRepository());

/// 사용자가 스크랩한 장소들의 ID Set을 관리
final scrapViewModelProvider =
    StateNotifierProvider<ScrapViewModel, Set<String>>((ref) {
  return ScrapViewModel(ref.read(scrapRepositoryProvider));
});

/// 실제 스크랩된 장소의 상세 정보 리스트를 불러옴
final scrapListViewModelProvider =
    StateNotifierProvider<ScrapListViewModel, AsyncValue<List<HomePlace>>>(
  (ref) => ScrapListViewModel(ref.read(scrapRepositoryProvider)),
);
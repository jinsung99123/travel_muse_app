import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/plan/search_history_repository.dart';

/// 최근 검색어를 관리하는 ViewModel (StateNotifier)
/// 앱 재시작 시에도 저장된 검색어를 복원합니다.
/// 내부적으로 [SearchHistoryRepository]를 사용해 로컬 저장소와 동기화합니다.
class RecentSearchVM extends StateNotifier<List<String>> {
  RecentSearchVM(this._repo) : super([]) {
    _init();
  }
  final SearchHistoryRepository _repo;

  Future<void> _init() async => state = await _repo.load();

  Future<void> add(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return;

    final newList = [trimmed, ...state.where((k) => k != trimmed)];
    if (newList.length > 6) newList.removeLast(); // 6개 유지

    state = newList;
    await _repo.save(newList);
  }

  Future<void> remove(String keyword) async {
    state = [...state]..remove(keyword);
    await _repo.save(state);
  }

  Future<void> clear() async {
    state = [];
    await _repo.save([]);
  }
}

/// 최근 검색어를 전역에서 관리하기 위한 Provider
final recentSearchProvider =
    StateNotifierProvider<RecentSearchVM, List<String>>(
      (ref) => RecentSearchVM(SearchHistoryRepository()),
    );

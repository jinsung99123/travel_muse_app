import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/search_history_repository.dart';

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
    if (newList.length > 6) newList.removeLast();   // 6개 유지

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

final recentSearchProvider =
    StateNotifierProvider<RecentSearchVM, List<String>>(
  (ref) => RecentSearchVM(SearchHistoryRepository()),
);

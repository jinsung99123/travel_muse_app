import 'package:shared_preferences/shared_preferences.dart';

/// 검색어 히스토리 관리 리포지토리
class SearchHistoryRepository {
  static const _key = 'recent_keywords';

  /// 저장된 최근 검색어 리스트를 불러옵니다.
  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// 최근 검색어 리스트를 저장합니다.
  Future<void> save(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, list);
  }
}

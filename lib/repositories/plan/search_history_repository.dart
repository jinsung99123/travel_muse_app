import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryRepository {
  static const _key = 'recent_keywords';

  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> save(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, list);
  }
}

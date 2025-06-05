import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/place.dart';
import 'package:travel_muse_app/services/place_search_service.dart';

class SearchViewModel extends StateNotifier<List<Map<String, String>>> {
  SearchViewModel(this._service) : super([]);
  final PlaceSearchService _service;


 Future<void> search(String query) async {
  try {
    final List<Place> places = await _service.search(query);

    final List<Map<String, String>> results = [];

    for (final place in places) {
      final imageUrl = await _service.fetchImageThumbnail(place.name); // 이미지 검색 호출
      results.add({
        'title': place.name,
        'subtitle': '${place.city} ${place.district} • ${place.category}',
        'image': imageUrl ?? 'https://cdn.pixabay.com/photo/2017/06/24/04/37/cloud-2436676_1280.jpg', // 기본 이미지 대체
      });
    }

    state = results;
  } catch (e) {
    state = [];
  }
}

}

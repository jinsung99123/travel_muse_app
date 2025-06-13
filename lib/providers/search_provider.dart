import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/place_search_service_provider.dart';
import 'package:travel_muse_app/viewmodels/search_view_model.dart';

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, List<Map<String, String>>>((ref) {
  final svc = ref.watch(placeSearchServiceProvider);  
  return SearchViewModel(svc);
});

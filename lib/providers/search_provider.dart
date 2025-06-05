import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/services/place_search_service.dart';
import 'package:travel_muse_app/viewmodels/search_view_model.dart';

final searchViewModelProvider = StateNotifierProvider<SearchViewModel, List<Map<String, String>>>(
  (ref) => SearchViewModel(PlaceSearchService()),
);

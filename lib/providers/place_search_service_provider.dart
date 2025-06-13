import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/services/place_search_service.dart';

final placeSearchServiceProvider = Provider<PlaceSearchService>((ref) {
  return PlaceSearchService();  
});

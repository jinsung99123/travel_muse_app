import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/repositories/location_repository.dart';

//레포지토리 인스턴스
final locationRepoProvider = Provider<LocationRepository>((ref) {
  return LocationRepository();
});

//현재 좌표
final locationProvider = FutureProvider<LatLng>((ref) async {
  final repo = ref.read(locationRepoProvider);
  return repo.getCurrent();
});

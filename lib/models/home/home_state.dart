import 'package:travel_muse_app/models/home/home_place.dart';

class HomeState {
  const HomeState({
    this.originalSpots = const <HomePlace>[],
    this.spots = const <HomePlace>[],
    this.foods = const <HomePlace>[],
    this.spotPage = 1,
    this.foodPage = 1,
  });

  final List<HomePlace> originalSpots;
  final List<HomePlace> spots;
  final List<HomePlace> foods;
  final int spotPage;
  final int foodPage;

  HomeState copyWith({
    List<HomePlace>? originalSpots,
    List<HomePlace>? spots,
    List<HomePlace>? foods,
    int? spotPage,
    int? foodPage,
  }) => HomeState(
    originalSpots: originalSpots ?? this.originalSpots,
    spots: spots ?? this.spots,
    foods: foods ?? this.foods,
    spotPage: spotPage ?? this.spotPage,
    foodPage: foodPage ?? this.foodPage,
  );
}

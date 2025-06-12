import 'package:travel_muse_app/models/home_place.dart';

class HomeState {
  const HomeState({
    this.spots = const <HomePlace>[],
    this.foods = const <HomePlace>[],
    this.spotPage = 1,
    this.foodPage = 1,
  });

  final List<HomePlace> spots;
  final List<HomePlace> foods;
  final int spotPage;
  final int foodPage;

  HomeState copyWith({
    List<HomePlace>? spots,
    List<HomePlace>? foods,
    int? spotPage,
    int? foodPage,
  }) =>
      HomeState(
        spots: spots ?? this.spots,
        foods: foods ?? this.foods,
        spotPage: spotPage ?? this.spotPage,
        foodPage: foodPage ?? this.foodPage,
      );
}

class MapState {
  MapState({
    required this.dayPlaces,
    this.selectedPlace,
    this.title,
    this.date,
  });

  final Map<String, List<Map<String, String>>> dayPlaces;
  final Map<String, dynamic>? selectedPlace;
  final String? title;
  final String? date;

  MapState copyWith({
    Map<String, List<Map<String, String>>>? dayPlaces,
    Map<String, dynamic>? selectedPlace,
    String? title,
    String? date,
  }) {
    return MapState(
      dayPlaces: dayPlaces ?? this.dayPlaces,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }
}

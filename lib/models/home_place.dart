import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/place.dart';

class HomePlace {
  HomePlace({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.latLng,
    required this.category,
    this.phone, 
    this.placeUrl, 
    this.isFavorite = false,
    this.distance,
  });

  final String id;
  final String title;
  final String subtitle;
  final String thumbnail;
  final LatLng latLng;
  final String category;
  final String? phone; 
  final String? placeUrl; 
  final bool isFavorite;
  final int? distance;

  factory HomePlace.fromPlace(Place p, {String thumb = '', int? distance}) {
    return HomePlace(
      id: p.id,
      title: p.name,
      subtitle: p.address,
      thumbnail: thumb,
      latLng: LatLng(p.latitude, p.longitude),
      category: p.category,
      phone: p.phone, 
      placeUrl: p.placeUrl, 
      distance: distance,
    );
  }
}

extension PlaceMapping on Place {
  HomePlace toHome({String thumb = '', int? distance}) => HomePlace(
    id: id,
    title: name,
    subtitle: address,
    thumbnail: thumb,
    latLng: LatLng(latitude, longitude),
    category: category,
    distance: distance,
  );
}

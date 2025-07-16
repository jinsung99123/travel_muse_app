import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/plan/place.dart';

class HomePlace {
  HomePlace({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.address,
    required this.thumbnail,
    required this.latLng,
    required this.category,
    this.phone,
    this.placeUrl,
    this.isFavorite = false,
    this.distance,
    this.categoryCode
  });

  final String id;
  final String title;
  final String subtitle;
  final String address;
  final String thumbnail;
  final LatLng latLng;
  final String category;
  final String? phone;
  final String? placeUrl;
  final bool isFavorite;
  final int? distance;
  final String? categoryCode; 

  factory HomePlace.fromPlace(Place p, {String thumb = '', int? distance}) {
    return HomePlace(
      id: p.id,
      title: p.name,
      subtitle: p.address,
      address: p.address,
      thumbnail: thumb,
      latLng: LatLng(p.latitude, p.longitude),
      category: p.category,
      phone: p.phone,
      placeUrl: p.placeUrl,
      distance: distance,
      categoryCode: p.categoryCode,
    );
  }

  factory HomePlace.fromMap(Map<String, dynamic> map) {
    return HomePlace(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      address: map['address'] ?? '',
      thumbnail: map['image'] ?? '',
      latLng: LatLng(
        double.tryParse(map['lat']?.toString() ?? '0') ?? 0,
        double.tryParse(map['lng']?.toString() ?? '0') ?? 0,
      ),
      category: map['category'] ?? '',
      phone: map['phone'],
      placeUrl: map['placeUrl'],
      isFavorite: map['isFavorite'] ?? false,
      distance: map['distance'],
      categoryCode: map['categoryCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'address': address,
      'image': thumbnail,
      'lat': latLng.latitude,
      'lng': latLng.longitude,
      'category': category,
      'phone': phone,
      'placeUrl': placeUrl,
      'isFavorite': isFavorite,
      'distance': distance,
      'categoryCode': categoryCode,
    };
  }
}

extension PlaceMapping on Place {
  HomePlace toHome({String thumb = '', int? distance}) => HomePlace(
    id: id,
    title: name,
    subtitle: address,
    address: address,
    thumbnail: thumb,
    latLng: LatLng(latitude, longitude),
    category: category,
    phone: phone,
    placeUrl: placeUrl,
    distance: distance,
    categoryCode: categoryCode,
  );
}

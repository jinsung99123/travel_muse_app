class Place {
  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.category,
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final String district;
  final double latitude;
  final double longitude;
  final String category;

  factory Place.fromKakaoJson(Map<String, dynamic> json) {
    final address = json['address_name'] ?? '';
    final addressParts = address.split(' ');

    return Place(
      id: json['id'] ?? '',
      name: json['place_name'] ?? '',
      address: address,
      city: addressParts.length > 0 ? addressParts[0] : '',
      district: addressParts.length > 1 ? addressParts[1] : '',
      latitude: double.tryParse(json['y'] ?? '0') ?? 0,
      longitude: double.tryParse(json['x'] ?? '0') ?? 0,
      category: json['category_name'] ?? '',
    );
  }
}

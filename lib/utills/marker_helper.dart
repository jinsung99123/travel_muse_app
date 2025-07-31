import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIconLoader {
  static BitmapDescriptor? _cachedIcon;

  static Future<BitmapDescriptor> loadCustomIcon() async {
    if (_cachedIcon != null) return _cachedIcon!;

    final icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/map-pin.png',
    );

    _cachedIcon = icon;
    return icon;
  }
}

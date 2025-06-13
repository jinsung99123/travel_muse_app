import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/home_place.dart';

class PlaceMapView extends StatelessWidget {
  const PlaceMapView({super.key, required this.place});

  final HomePlace place;

  @override
  Widget build(BuildContext context) {
    final LatLng position = place.latLng;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 200,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 13,
          ),
          markers: {
            Marker(
              markerId: MarkerId(place.id),
              position: position,
              infoWindow: InfoWindow(title: place.title),
            ),
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onTap: (_) {
            // 추후 추가 예정 지도 상세로 이동
          },
        ),
      ),
    );
  }
}

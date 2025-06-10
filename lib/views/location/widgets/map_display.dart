import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDisplay extends StatelessWidget {
  const MapDisplay({
    super.key,
    required this.initialLatLng,
    required this.points,
    required this.markers,
    required this.onMapCreated,
  });

  final LatLng initialLatLng;
  final List<LatLng> points;
  final Set<Marker> markers;
  final void Function(GoogleMapController) onMapCreated;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialLatLng,
        zoom: 14,
      ),
      markers: markers,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      compassEnabled: true,
      polylines: {
        if (points.length >= 2)
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.red,
            width: 3,
          ),
      },
      onMapCreated: onMapCreated,
    );
  }
}

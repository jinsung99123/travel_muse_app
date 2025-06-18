import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

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
            polylineId: PolylineId('route'),
            points: points,
            color: AppColors.secondary[400]!,       
            width: 2,
            patterns: [
              PatternItem.dash(20),        
              PatternItem.gap(10),                  
            ],
            jointType: JointType.round,       
          ),
      },

      onMapCreated: onMapCreated,
    );
  }
}

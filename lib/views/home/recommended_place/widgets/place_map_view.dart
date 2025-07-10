import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/utills/marker_helper.dart';

class PlaceMapView extends StatefulWidget {
  const PlaceMapView({super.key, required this.place});
  final HomePlace place;

  @override
  State<PlaceMapView> createState() => _PlaceMapViewState();
}

class _PlaceMapViewState extends State<PlaceMapView>
    with AutomaticKeepAliveClientMixin {
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    _initMarker();
  }

  Future<void> _initMarker() async {
    final icon = await MarkerIconLoader.loadCustomIcon();
    setState(() {
      _customIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    final LatLng position = widget.place.latLng;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 200,
        child: _customIcon == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                key: ValueKey(widget.place.id), 
                initialCameraPosition: CameraPosition(
                  target: position,
                  zoom: 13,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.place.id),
                    position: position,
                    icon: _customIcon!,
                    infoWindow: InfoWindow(title: widget.place.title),
                  ),
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onTap: (_) {},
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

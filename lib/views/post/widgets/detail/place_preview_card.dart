import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePreviewCard extends StatefulWidget {
  const PlacePreviewCard({
    super.key,
    required this.title,
    required this.address,
    required this.latLng,
  });

  final String title;
  final String address;
  final LatLng latLng;

  @override
  State<PlacePreviewCard> createState() => _PlacePreviewCardState();
}

class _PlacePreviewCardState extends State<PlacePreviewCard> {
  BitmapDescriptor? _customMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    // ignore: deprecated_member_use
    final marker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/map-pin6.png',
    );
    setState(() {
      _customMarker = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cameraPosition = CameraPosition(target: widget.latLng, zoom: 14);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox(
              height: 165,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: cameraPosition,
                markers:
                    _customMarker == null
                        ? {}
                        : {
                          Marker(
                            markerId: const MarkerId('preview_marker'),
                            position: widget.latLng,
                            icon: _customMarker!,
                          ),
                        },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                onTap: (_) {},
                liteModeEnabled: true,
              ),
            ),
            // 블러 + 텍스트
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.address,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

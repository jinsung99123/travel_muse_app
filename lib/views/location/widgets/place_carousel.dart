import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/map_state.dart';
import 'package:travel_muse_app/utills/latlng_helper.dart';
import 'package:travel_muse_app/viewmodels/map_view_model.dart';
import 'package:travel_muse_app/views/location/widgets/place_card.dart';

class PlaceCarousel extends StatelessWidget {
  const PlaceCarousel({
    super.key,
    required this.dayKeys,
    required this.mapState,
    required this.viewModel,
    required this.tabController,
    required this.selectedPlace,
    required this.mapController,
  });

  final List<String> dayKeys;
  final MapState mapState;
  final MapViewModel viewModel;
  final TabController tabController;
  final Map<String, dynamic>? selectedPlace;
  final GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: dayKeys.map((day) {
        final places = mapState.dayPlaces[day] ?? [];
        final pageController = viewModel.getPageController(day);

        return PageView.builder(
          itemCount: places.length,
          controller: pageController,
          onPageChanged: (index) {
            final place = places[index];
            final latLng = parseLatLng(place);  // 헬퍼 함수 사용!
            if (latLng != null) {
              mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(
                  latLng,
                  14,
                ),
              );
            }
            viewModel.selectPlace(place);
          },
          itemBuilder: (context, index) {
            final place = places[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12,
              ),
              child: PlaceCard(
                placeData: place,
                isSelected: selectedPlace?['id'] == place['id'],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

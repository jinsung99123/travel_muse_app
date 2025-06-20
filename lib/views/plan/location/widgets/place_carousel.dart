import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/models/plan/map_state.dart';
import 'package:travel_muse_app/utills/latlng_helper.dart';
import 'package:travel_muse_app/viewmodels/plan/map_view_model.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';
import 'package:travel_muse_app/views/plan/location/widgets/place_card.dart';

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
    final allPlaces = viewModel.getAllPlaces();
    final allController = viewModel.getPageController('all');

    return TabBarView(
      controller: tabController,
      children: [
        PageView.builder(
          itemCount: allPlaces.length,
          controller: allController,
          onPageChanged: (index) {
            final place = allPlaces[index];
            final latLng = parseLatLng(place);
            if (latLng != null) {
              mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(latLng, 14),
              );
            }
            viewModel.selectPlace(place);
          },
          itemBuilder: (context, index) {
            final place = allPlaces[index];
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
        ),

        for (final day in dayKeys)
          Builder(
            builder: (context) {
              final places = mapState.dayPlaces[day] ?? [];
              final pageController = viewModel.getPageController(day);

              return PageView.builder(
                itemCount: places.length,
                controller: pageController,
                onPageChanged: (index) {
                  final place = places[index];
                  final latLng = parseLatLng(place);
                  if (latLng != null) {
                    mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(latLng, 14),
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
                      onTap: () {
                        final homePlace = HomePlace.fromMap(place); 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RecommendedPlaceDetailPage(
                                  place: homePlace,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}

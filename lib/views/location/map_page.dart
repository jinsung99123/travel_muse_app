import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/providers/map_provider.dart';
import 'package:travel_muse_app/views/Location/widgets/day_tab_bar.dart';
import 'package:travel_muse_app/views/location/widgets/map_display.dart';
import 'package:travel_muse_app/views/location/widgets/place_carousel.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key, required this.planId});
  final String planId;

  @override
  ConsumerState<MapPage> createState() => MapPageState();
}

class MapPageState extends ConsumerState<MapPage>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  bool _cameraMoved = false;
  LatLng _initialLatLng = const LatLng(33.4996, 126.5312);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(mapViewModelProvider.notifier)
          .loadPlanAndRoute(widget.planId, this);
    });
  }

  @override
  void dispose() {
    ref.read(mapViewModelProvider.notifier).disposeControllers();
    super.dispose();
  }

  void _moveCameraToFitAll(List<Map<String, dynamic>> places) {
    final viewModel = ref.read(mapViewModelProvider.notifier);
    final latLngs = viewModel.extractLatLngs(places);

    if (latLngs.length >= 2) {
      final bounds = viewModel.createLatLngBounds(latLngs);
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    } else if (latLngs.isNotEmpty) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLngs.first, 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapViewModelProvider);
    final viewModel = ref.read(mapViewModelProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;
    final dayKeys = mapState.dayPlaces.keys.toList();
    final selectedPlace = mapState.selectedPlace;

    if (dayKeys.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tabController = viewModel.tabController;
    if (tabController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {});
        final newPlaces =
            mapState.dayPlaces[dayKeys[tabController.index]] ?? [];
        _moveCameraToFitAll(newPlaces);
      }
    });

    final selectedDayKey = dayKeys[tabController.index];
    final selectedPlaces = mapState.dayPlaces[selectedDayKey] ?? [];

    if (!_cameraMoved && selectedPlaces.isNotEmpty) {
      final initial = viewModel.getInitialLatLng(selectedPlaces);
      if (initial != null) {
        _initialLatLng = initial;
      }
    }

    final points = viewModel.extractLatLngs(selectedPlaces);

    final markers =
        selectedPlaces
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final place = entry.value;
              final lat =
                  double.tryParse(place['lat'] ?? '') ??
                  double.tryParse(place['latitude'] ?? '');
              final lng =
                  double.tryParse(place['lng'] ?? '') ??
                  double.tryParse(place['longitude'] ?? '');
              if (lat == null || lng == null) return null;

              return Marker(
                markerId: MarkerId(
                  place['id'] ?? '${lat}_${lng}_${place['title']}',
                ),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: '${index + 1}. ${place['title'] ?? ''}',
                ),
                onTap: () {
                  viewModel.selectPlace(place);
                  final idx = selectedPlaces.indexWhere(
                    (p) =>
                        (p['id'] != null && p['id'] == place['id']) ||
                        (p['title'] == place['title'] &&
                            p['lat'] == place['lat'] &&
                            p['lng'] == place['lng']),
                  );
                  if (idx != -1) {
                    viewModel
                        .getPageController(selectedDayKey)
                        .animateToPage(
                          idx,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                  }
                },
              );
            })
            .whereType<Marker>()
            .toSet();

    final displayDayTabs =
        dayKeys.map((key) {
          final num = int.tryParse(key.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return 'Day ${num + 1}';
        }).toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapDisplay(
              initialLatLng: _initialLatLng,
              points: points,
              markers: markers,
              onMapCreated: (controller) {
                _mapController = controller;
                if (!_cameraMoved && selectedPlaces.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _moveCameraToFitAll(selectedPlaces);
                    _cameraMoved = true;
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: screenHeight * 0.28,
            child: Column(
              children: [
                DayTabBar(controller: tabController, days: displayDayTabs),
                Expanded(
                  child: PlaceCarousel(
                    dayKeys: dayKeys,
                    mapState: mapState,
                    viewModel: viewModel,
                    selectedPlace: selectedPlace,
                    mapController: _mapController,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

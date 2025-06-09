import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/providers/map_provider.dart';
import 'package:travel_muse_app/utills/latlng_helper.dart';
import 'package:travel_muse_app/viewmodels/map_view_model.dart';
import 'package:travel_muse_app/views/location/widgets/day_tab_bar.dart';
import 'package:travel_muse_app/views/location/widgets/map_display.dart';
import 'package:travel_muse_app/views/location/widgets/place_carousel.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key, required this.planId});
  final String planId;

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  bool _cameraMoved = false;
  LatLng _initialLatLng = const LatLng(33.4996, 126.5312);

  late final MapViewModel _viewModel;
  TabController? _tabController;

  void _onTabChanged() {
    if (!mounted) return;
    final mapState = ref.read(mapViewModelProvider);
    final dayKeys = mapState.dayPlaces.keys.toList();

    if (_tabController == null || dayKeys.isEmpty) return;

    if (!_tabController!.indexIsChanging) {
      setState(() {});
      final newPlaces =
          mapState.dayPlaces[dayKeys[_tabController!.index]] ?? [];
      _moveCameraToFitAll(newPlaces);
    }
  }

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(mapViewModelProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _viewModel.loadPlanAndRoute(widget.planId, this);

      final dayKeys = ref.read(mapViewModelProvider).dayPlaces.keys.toList();
      if (dayKeys.isEmpty) return;

      _tabController = TabController(length: dayKeys.length, vsync: this);
      _tabController!.addListener(_onTabChanged);

      setState(() {});
    });
  }

  @override
  void dispose() {
    try {
      _tabController?.removeListener(_onTabChanged);
      _tabController?.dispose();
      _viewModel.disposeControllers();
    } catch (e) {
      debugPrint('💥 dispose error: $e');
    }
    super.dispose();
  }

  void _moveCameraToFitAll(List<Map<String, dynamic>> places) {
    final latLngs = _viewModel.extractLatLngs(places);

    if (latLngs.length >= 2) {
      final bounds = _viewModel.createLatLngBounds(latLngs);
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
    final screenHeight = MediaQuery.of(context).size.height;

    final dayKeys = mapState.dayPlaces.keys.toList();
    if (_tabController == null || dayKeys.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final index = _tabController!.index;
    if (index >= dayKeys.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final selectedDayKey = dayKeys[index];
    final selectedPlaces = mapState.dayPlaces[selectedDayKey] ?? [];

    if (!_cameraMoved && selectedPlaces.isNotEmpty) {
      final initial = _viewModel.getInitialLatLng(selectedPlaces);
      if (initial != null) {
        _initialLatLng = initial;
      }
    }

    final points = _viewModel.extractLatLngs(selectedPlaces);

    final markers =
        selectedPlaces
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final place = entry.value;
              final LatLng? latLng = parseLatLng(place);
              if (latLng == null) return null;
              final lat = latLng.latitude;
              final lng = latLng.longitude;

              return Marker(
                markerId: MarkerId(
                  place['id'] ?? '${lat}_${lng}_${place['title']}',
                ),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: '${index + 1}. ${place['title'] ?? ''}',
                ),
                onTap: () {
                  _viewModel.selectPlace(place);
                  final idx = selectedPlaces.indexWhere(
                    (p) =>
                        (p['id'] != null && p['id'] == place['id']) ||
                        (p['title'] == place['title'] &&
                            p['lat'] == place['lat'] &&
                            p['lng'] == place['lng']),
                  );
                  if (idx != -1) {
                    _viewModel
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
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mapState.title ?? '여행 계획',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (mapState.date != null)
              Text(
                mapState.date!,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
          ],
        ),
      ),
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
                DayTabBar(controller: _tabController!, days: displayDayTabs),
                Expanded(
                  child: PlaceCarousel(
                    dayKeys: dayKeys,
                    mapState: mapState,
                    viewModel: _viewModel,
                    selectedPlace: mapState.selectedPlace,
                    mapController: _mapController,
                    tabController: _tabController!,
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

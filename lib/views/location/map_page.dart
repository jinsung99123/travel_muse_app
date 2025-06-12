import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/providers/map_provider.dart';
import 'package:travel_muse_app/utills/map_utils.dart';
import 'package:travel_muse_app/viewmodels/map_view_model.dart';
import 'package:travel_muse_app/views/location/widgets/day_tab_bar.dart';
import 'package:travel_muse_app/views/location/widgets/map_display.dart';
import 'package:travel_muse_app/views/location/widgets/map_page_app_bar.dart';
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
      _viewModel.moveCameraToFitAll(_mapController, newPlaces);
    }
  }

  bool _isLoading(TabController? tabController, List<String> dayKeys) {
    if (tabController == null || dayKeys.isEmpty) return true;
    if (tabController.index >= dayKeys.length) return true;
    return false;
  }
  
  Future<void> initializeControllers() async {
  if (!mounted) return;
  await _viewModel.loadPlanAndRoute(widget.planId, this);

  final dayKeys = ref.read(mapViewModelProvider).dayPlaces.keys.toList();
  if (dayKeys.isEmpty) return;

  _tabController = TabController(length: dayKeys.length, vsync: this);
  _tabController!.addListener(_onTabChanged);

  setState(() {});
}

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(mapViewModelProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
    initializeControllers();
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

  void _initCameraPosition(List<Map<String, dynamic>> selectedPlaces) {
  if (!_cameraMoved && selectedPlaces.isNotEmpty) {
    final initial = _viewModel.getInitialLatLng(selectedPlaces);
    if (initial != null) {
      _initialLatLng = initial;
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapViewModelProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final dayKeys = mapState.dayPlaces.keys.toList();
    if (_isLoading(_tabController, dayKeys)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final index = _tabController!.index;
    final selectedDayKey = dayKeys[index];
    final selectedPlaces = mapState.dayPlaces[selectedDayKey] ?? [];

     _initCameraPosition(selectedPlaces);

    final points = _viewModel.extractLatLngs(selectedPlaces);
    final markers = _viewModel.getMarkers(
      places: selectedPlaces,
      selectedDayKey: selectedDayKey,
      onTap: (place) => _viewModel.selectPlace(place),
      onPageChanged: (index) {
        if (!_tabController!.indexIsChanging) {
          setState(() {});
        }
      },
    );
    final displayDayTabs = dayKeys.map(getDisplayDayTab).toList();
    return Scaffold(
      appBar: MapPageAppBar(),
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
                    _viewModel.moveCameraToFitAll(_mapController, selectedPlaces);
                    _cameraMoved = true;
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: screenHeight * 0.25,
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

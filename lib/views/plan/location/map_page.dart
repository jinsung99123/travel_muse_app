import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/plan/schedule/map_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/search_provider.dart';
import 'package:travel_muse_app/utills/map_utils.dart';
import 'package:travel_muse_app/viewmodels/plan/map_view_model.dart';
import 'package:travel_muse_app/views/plan/location/widgets/day_tab_bar.dart';
import 'package:travel_muse_app/views/plan/location/widgets/map_display.dart';
import 'package:travel_muse_app/views/plan/location/widgets/map_page_app_bar.dart';
import 'package:travel_muse_app/views/plan/location/widgets/place_carousel.dart';
import 'package:travel_muse_app/views/plan/location/widgets/search_input_field.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key, required this.planId, this.isSelectMode = false});
  final String planId;
  final bool isSelectMode;

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  bool _cameraMoved = false;
  bool get isSelectMode => widget.planId == 'place-select-mode';
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

      final index = _tabController!.index;

      if (index == 0) {
        final allPlaces = _viewModel.getAllPlaces();
        _viewModel.moveCameraToFitAll(_mapController, allPlaces);
      } else {
        final newPlaces =
            mapState.dayPlaces[dayKeys[_tabController!.index - 1]] ?? [];
        _viewModel.moveCameraToFitAll(_mapController, newPlaces);
      }
    }
  }

  bool _isLoading(TabController? tabController, List<String> dayKeys) {
    if (tabController == null || dayKeys.isEmpty) return true;
    if (tabController.index >= dayKeys.length + 1) return true;
    return false;
  }

  Future<void> initializeControllers() async {
    if (!mounted) return;
    if (isSelectMode) {
      ref.read(mapViewModelProvider.notifier).setDummyDayPlaces();
      _tabController = TabController(length: 1, vsync: this);
      setState(() {});
      return;
    }

    await _viewModel.loadPlanAndRoute(widget.planId, this);

    final dayKeys = ref.read(mapViewModelProvider).dayPlaces.keys.toList();
    if (dayKeys.isEmpty) return;

    _tabController = TabController(length: dayKeys.length + 1, vsync: this);
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
    if (!_cameraMoved) {
      if (selectedPlaces.isNotEmpty) {
        final initial = _viewModel.getInitialLatLng(selectedPlaces);
        if (initial != null) {
          _initialLatLng = initial;
        }
      } else {
        /// 장소 없을 때 기본 좌표
        _initialLatLng = const LatLng(37.5665, 126.9780); // 서울 시청
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
    List<Map<String, dynamic>> selectedPlaces;
    if (index == 0) {
      selectedPlaces = _viewModel.getAllPlaces();
    } else {
      selectedPlaces = mapState.dayPlaces[dayKeys[index - 1]] ?? [];
    }

    _initCameraPosition(selectedPlaces);

    final points = _viewModel.extractLatLngs(selectedPlaces);
    final markers = _viewModel.getMarkers(
      places: selectedPlaces,
      selectedDayKey: index == 0 ? 'all' : dayKeys[index - 1],
      onTap: (place) => _viewModel.selectPlace(place),
      onPageChanged: (index) {
        if (!_tabController!.indexIsChanging) {
          setState(() {});
        }
      },
      isSelectMode: isSelectMode,
      context: context,
    );
    final displayDayTabs = ['All', ...dayKeys.map(getDisplayDayTab)];
    return Scaffold(
      appBar: MapPageAppBar(),

      body: Stack(
        children: [
          /// 1. 지도는 전체를 꽉 채움
          Positioned.fill(
            child: MapDisplay(
              initialLatLng: _initialLatLng,
              points: points,
              markers: markers,
              onMapCreated: (controller) {
                _mapController = controller;
                if (!_cameraMoved && selectedPlaces.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _viewModel.moveCameraToFitAll(
                      _mapController,
                      selectedPlaces,
                    );
                    _cameraMoved = true;
                  });
                }
              },
            ),
          ),

          /// 2. 검색창은 상단에 고정 (선택모드일 때만)
          if (isSelectMode)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: SearchInputField(
                onSearch:
                    (query) => ref
                        .read(searchViewModelProvider.notifier)
                        .search(query),
              ),
            ),

          /// 3. 하단 영역: DayTabBar 또는 PlaceCarousel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  if (!isSelectMode)
                    Container(
                      color: Colors.white,
                      child: DayTabBar(
                        controller: _tabController!,
                        days: displayDayTabs,
                      ),
                    ),
                  if (!isSelectMode)
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: PlaceCarousel(
                          dayKeys: dayKeys,
                          mapState: mapState,
                          viewModel: _viewModel,
                          selectedPlace: mapState.selectedPlace,
                          mapController: _mapController,
                          tabController: _tabController!,
                          isSelectMode: widget.isSelectMode,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

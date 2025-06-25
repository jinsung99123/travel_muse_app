import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/providers/plan/schedule/map_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/place_search_service_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/search_provider.dart';
import 'package:travel_muse_app/viewmodels/plan/map_view_model.dart';
import 'package:travel_muse_app/views/plan/location/widgets/map_display.dart';
import 'package:travel_muse_app/views/plan/location/widgets/map_page_app_bar.dart';
import 'package:travel_muse_app/views/plan/location/widgets/search_input_field.dart';

class SelectPlaceMapPage extends ConsumerStatefulWidget {
  const SelectPlaceMapPage({
    super.key,
    required this.planId,
    required this.isSelectMode,
  });

  final String planId;
  final bool isSelectMode;

  @override
  ConsumerState<SelectPlaceMapPage> createState() => _SelectPlaceMapPageState();
}

class _SelectPlaceMapPageState extends ConsumerState<SelectPlaceMapPage> {
  GoogleMapController? _mapController;
  bool _cameraMoved = false;
  LatLng _initialLatLng = const LatLng(37.5665, 126.9780); // 서울시청

  late final MapViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(mapViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.setDummyDayPlaces();
    });
  }

  @override
  void dispose() {
    try {
      _viewModel.disposeControllers();
    } catch (e) {
      debugPrint('💥 dispose error: $e');
    }
    super.dispose();
  }

  void _initCameraPosition(List<Map<String, dynamic>> places) {
    if (!_cameraMoved && places.isNotEmpty) {
      final latLng = _viewModel.getInitialLatLng(places);
      if (latLng != null) {
        _initialLatLng = latLng;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapViewModelProvider);
    final places = mapState.dayPlaces['select'] ?? [];
    _initCameraPosition(places);

    final points = _viewModel.extractLatLngs(places);
    final markers = _viewModel.getMarkers(
      places: places,
      selectedDayKey: 'select',
      isSelectMode: true,
      context: context,
      onTap: (place) => _viewModel.selectPlace(place),
      onPageChanged: (_) {},
    );

    return Scaffold(
      appBar: MapPageAppBar(),
      body: Stack(
        children: [
          /// 지도 전체 표시
          Positioned.fill(
            child: MapDisplay(
              initialLatLng: _initialLatLng,
              points: points,
              markers: markers,
              onMapCreated: (controller) {
                _mapController = controller;
                if (!_cameraMoved && places.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _viewModel.moveCameraToFitAll(_mapController, places);
                    _cameraMoved = true;
                  });
                }
              },
            ),
          ),

          /// 검색창 고정
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SearchInputField(
              onSearch: (query) async {
                final viewModel = ref.read(mapViewModelProvider.notifier);
                final placeService = ref.read(placeSearchServiceProvider);
                final controller = _mapController;

                if (controller != null) {
                  await viewModel.moveCameraToPlace(
                    mapController: controller,
                    query: query,
                    placeService: placeService,
                  );
                }

                // 기존 검색 결과도 그대로 반영
                await ref.read(searchViewModelProvider.notifier).search(query);
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/views/Location/widgets/day_tab_bar.dart';
import 'package:travel_muse_app/views/Location/widgets/place_card.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> days = ['day1', 'day2', 'day3', 'day4'];

  final Map<String, List<String>> dayPlaces = {
    'day1': ['우동야 고야쵸', '히로시마 신사'],
    'day2': ['카페모카', '리버사이드 거리'],
    'day3': ['전망대', '오코노미야끼 맛집'],
    'day4': ['공원', '도보 산책길'],
  };

  // late GoogleMapController _mapController; 추후 사용 예정

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(33.4996, 126.5312), // 제주 시내 예시
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: days.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 지도영역
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) {
                // _mapController = controller; 추후 사용 예정
              },
              myLocationEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),

          // 하단 카드 + 탭 영역
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.28,
            child: Column(
              children: [
                DayTabBar(controller: _tabController, days: days),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children:
                        days.map((day) {
                          final places = dayPlaces[day] ?? [];
                          return PageView.builder(
                            itemCount: places.length,
                            controller: PageController(viewportFraction: 0.85),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 12,
                                ),
                                child: PlaceCard(
                                  title: places[index],
                                  description: '장소 설명 텍스트',
                                ),
                              );
                            },
                          );
                        }).toList(),
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

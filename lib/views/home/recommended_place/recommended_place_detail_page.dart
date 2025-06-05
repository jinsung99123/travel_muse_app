import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/action_button_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/image_slider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/location_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_description.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_direction_info.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_info_section.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_map_view.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_stats_row.dart';

class RecommendedPlaceDetailPage extends StatefulWidget {
  const RecommendedPlaceDetailPage({super.key});

  @override
  State<RecommendedPlaceDetailPage> createState() =>
      _RecommendedPlaceDetailPageState();
}

class _RecommendedPlaceDetailPageState
    extends State<RecommendedPlaceDetailPage> {
  final Color primaryColor = const Color(0xFF03A9F4);
  final Color secondaryColor = const Color(0xFF1E88E5);

  final List<String> imageUrls = [
    'assets/images/image1.png',
    'assets/images/image2.png',
  ];

  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('두물머리'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: secondaryColor,
        icon: const Icon(Icons.navigation),
        label: const Text('길찾기'),
        onPressed: () {
          // 위치 서비스 연동 예정
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 이미지 슬라이더
            ImageSlider(
              imageUrls: imageUrls,
              currentPage: _currentPage,
              pageController: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
            ),
            const SizedBox(height: 16),

            const PlaceStatsRow(),
            const SizedBox(height: 12),

            const LocationRow(),
            const SizedBox(height: 24),

            const ActionButtonRow(),
            const SizedBox(height: 24),

            const PlaceDescription(),
            const SizedBox(height: 24),

            const PlaceMapView(),
            const SizedBox(height: 16),

            const PlaceInfoSection(),

            const PlaceDirectionInfo(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

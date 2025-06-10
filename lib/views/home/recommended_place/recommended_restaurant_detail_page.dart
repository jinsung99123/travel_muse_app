import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/action_button_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/image_slider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/location_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_direction_info.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_map_view.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_stats_row.dart';

class RecommendedRestaurantDetailPage extends StatefulWidget {
  const RecommendedRestaurantDetailPage({super.key});

  @override
  State<RecommendedRestaurantDetailPage> createState() =>
      _RecommendedRestaurantDetailPageState();
}

class _RecommendedRestaurantDetailPageState
    extends State<RecommendedRestaurantDetailPage> {
  final Color primaryColor = const Color(0xFF03A9F4);
  final Color secondaryColor = const Color(0xFF1E88E5);

  final List<String> imageUrls = ['assets/images/image3.png'];

  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('핫도그 두물머리점'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE0F7FA),
        foregroundColor: const Color(0xFF03A9F4),
        icon: const Icon(Icons.restaurant),
        label: const Text('길찾기'),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF03A9F4), width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          //TODO 위치 서비스 연동 예정
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // 다른 설명만 바뀜
            const Text(
              '두물머리 인증샷 명소 바로 앞! 바삭하고 치즈가득한 수제 핫도그로 유명한 곳.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            const PlaceMapView(),
            const SizedBox(height: 16),

            const Text('주소: 경기 양평군 양서면 두물머리길'),
            const Text('전화: 031-000-0000'),
            const Text('홈페이지: 없음', style: TextStyle(color: Colors.grey)),

            const PlaceDirectionInfo(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

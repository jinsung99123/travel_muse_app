import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/action_button_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/image_slider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/location_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_description.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_info_section.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_map_view.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_stats_row.dart';

class RecommendedPlaceDetailPage extends StatefulWidget {
  const RecommendedPlaceDetailPage({super.key, required this.place});
  final HomePlace place;

  @override
  State<RecommendedPlaceDetailPage> createState() =>
      _RecommendedPlaceDetailPageState();
}

class _RecommendedPlaceDetailPageState
    extends State<RecommendedPlaceDetailPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0, 
        title: Row(
          children: [
            IconButton(
              icon:  Icon(Icons.chevron_left, color: AppColors.grey[500], size: 24,),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 4),
            Text(
              place.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: 'Pretendard'
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE0F7FA),
        foregroundColor: const Color(0xFF03A9F4),
        icon: const Icon(Icons.directions),
        label: const Text('길찾기'),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF03A9F4), width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          final lat = place.latLng.latitude;
          final lng = place.latLng.longitude;
          final name = place.title;
          // final url = Uri.parse('https://map.kakao.com/link/map/$name,$lat,$lng'); 추후 추가 예정
          // launchUrl(url);  // launch(url.toString()); 필요시 url_launcher 사용
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSlider(
              imageUrls: [place.thumbnail],
              currentPage: _currentPage,
              pageController: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
            ),
            const SizedBox(height: 16),
            PlaceStatsRow(),
            const SizedBox(height: 12),
            LocationRow(place: widget.place),
            const SizedBox(height: 24),
            const ActionButtonRow(),
            const SizedBox(height: 24),
            PlaceDescription(),
            const SizedBox(height: 24),
            PlaceMapView(place: widget.place),
            const SizedBox(height: 16),
            PlaceInfoSection(place: widget.place),
            // const PlaceDirectionInfo(), 추후 추가 고려
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

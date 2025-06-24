import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/action_button_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/image_slider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/location_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_description.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_info_section.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_map_view.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_stats_row.dart';

class RecommendedPlaceDetailSheet extends StatefulWidget {
  const RecommendedPlaceDetailSheet({
    super.key,
    required this.place,
    this.scrollController,
  });

  final HomePlace place;
  final ScrollController? scrollController;

  @override
  State<RecommendedPlaceDetailSheet> createState() =>
      _RecommendedPlaceDetailSheetState();
}

class _RecommendedPlaceDetailSheetState
    extends State<RecommendedPlaceDetailSheet> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        // 스크롤 가능한 컨텐츠
        Padding(
          padding: EdgeInsets.only(bottom: 80 + bottomPadding),
          child: SingleChildScrollView(
            controller: widget.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 닫기 버튼 + 제목
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      place.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 이미지, 설명 등
                ImageSlider(
                  imageUrls: [place.thumbnail],
                  currentPage: _currentPage,
                  pageController: _pageController,
                  onPageChanged:
                      (index) => setState(() => _currentPage = index),
                ),
                const SizedBox(height: 16),
                LocationRow(place: place),
                const SizedBox(height: 24),
                PlaceDescription(),
                const SizedBox(height: 24),
                const SizedBox(height: 16),
                PlaceInfoSection(place: place),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),

        // 하단 고정된 버튼
        Positioned(
          left: 16,
          right: 16,
          bottom: 16 + bottomPadding,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary[300],
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, {
                'title': place.title,
                'lat': place.latLng.latitude,
                'lng': place.latLng.longitude,
                'address': place.address,
              });
            },
            child: const Text('선택하기', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

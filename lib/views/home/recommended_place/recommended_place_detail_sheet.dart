import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/image_slider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/location_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_info_section.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_map_view.dart';

class RecommendedPlaceDetailSheet extends ConsumerStatefulWidget {
  const RecommendedPlaceDetailSheet({
    super.key,
    required this.place,
    this.scrollController,
  });

  final HomePlace place;
  final ScrollController? scrollController;

  @override
  ConsumerState<RecommendedPlaceDetailSheet> createState() =>
      _RecommendedPlaceDetailSheetState();
}

class _RecommendedPlaceDetailSheetState
    extends ConsumerState<RecommendedPlaceDetailSheet> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

            child: SizedBox(
              width: double.infinity,
              child: Text(
                place.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 컨텐츠
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageSlider(
                    imageUrls: [place.thumbnail],
                    currentPage: _currentPage,
                    pageController: _pageController,
                    onPageChanged:
                        (index) => setState(() => _currentPage = index),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        LocationRow(place: place),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/alert-circle.svg',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '매장 정보',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        PlaceMapView(place: place),
                        const SizedBox(height: 16),
                        PlaceInfoSection(place: place),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPadding),
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
      ),
    );
  }
}

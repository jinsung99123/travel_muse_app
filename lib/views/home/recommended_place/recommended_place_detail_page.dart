import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/providers/home/scrap_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/image_slider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/location_row.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_description.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_info_section.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_map_view.dart';

class RecommendedPlaceDetailPage extends ConsumerStatefulWidget {
  const RecommendedPlaceDetailPage({super.key, required this.place});
  final HomePlace place;

  @override
  ConsumerState<RecommendedPlaceDetailPage> createState() =>
      _RecommendedPlaceDetailPageState();
}

class _RecommendedPlaceDetailPageState extends ConsumerState<RecommendedPlaceDetailPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final isScrapped = ref.watch(scrapViewModelProvider).contains(place.id);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(place.title, style: AppTextStyles.appBarTitle),
        centerTitle: true,
        leading: GestureDetector(
          onTap:
              () => Navigator.pop(context, {
                'title': place.title,
                'lat': place.latLng.latitude,
                'lng': place.latLng.longitude,
                'address': place.address,
              }),

          child: Container(
            padding: EdgeInsets.only(top: 4),
            width: 44,
            height: 44,
            color: Colors.amber,
            child: SvgPicture.asset(
              'assets/icons/chevron-left.svg',
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        actions: [
          IconButton(
            iconSize: 24,
            icon: Icon(
              isScrapped ? Icons.bookmark : Icons.bookmark_border,
              color: isScrapped ? AppColors.primary[300] : AppColors.black,
            ),
            onPressed: () {
              ref.read(scrapViewModelProvider.notifier).toggleScrap(place);
              CustomToast.show(
                context: context,
                message: '북마크에 저장했습니다.',
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: AppColors.primary[50],
      //   foregroundColor: AppColors.primary[300],
      //   icon: const Icon(Icons.directions),
      //   label: const Text('길찾기'),
      //   shape: RoundedRectangleBorder(
      //     side: BorderSide(color: AppColors.primary[300]!, width: 1.5),
      //     borderRadius: BorderRadius.circular(16),
      //   ),
      //   onPressed: () {
      //     final lat = place.latLng.latitude;
      //     final lng = place.latLng.longitude;
      //     final name = place.title;
      //     // final url = Uri.parse('https://map.kakao.com/link/map/$name,$lat,$lng'); 추후 추가 예정
      //     // launchUrl(url);  // launch(url.toString()); 필요시 url_launcher 사용
      //   },
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(
              imageUrls: [place.thumbnail],
              currentPage: _currentPage,
              pageController: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 16),
                  // PlaceStatsRow(), 별점 좋아요
                  Text(
                    place.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 12),
                  LocationRow(place: place),
                  const SizedBox(height: 24),
                  // const ActionButtonRow(),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/alert-circle.svg',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '매장 정보',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PlaceDescription(),
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
      bottomNavigationBar: const BottomBar(),
    );
  }
}

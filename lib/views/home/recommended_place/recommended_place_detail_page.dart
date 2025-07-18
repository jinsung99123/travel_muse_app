import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/providers/home/place_detail_provider.dart';
import 'package:travel_muse_app/providers/home/scrap_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/image_slider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_detail_section.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_map_view.dart';

class RecommendedPlaceDetailPage extends ConsumerStatefulWidget {
  const RecommendedPlaceDetailPage({super.key, required this.place});
  final HomePlace place;

  @override
  ConsumerState<RecommendedPlaceDetailPage> createState() =>
      _RecommendedPlaceDetailPageState();
}

class _RecommendedPlaceDetailPageState
    extends ConsumerState<RecommendedPlaceDetailPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(placeDetailViewModelProvider.notifier)
          .fetchDetail(
            widget.place.title,
            widget.place.address,
            widget.place.latLng.latitude,
            widget.place.latLng.longitude,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final isScrapped = ref.watch(scrapViewModelProvider).contains(place.id);
    final detail = ref.watch(placeDetailViewModelProvider);

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
            color: Colors.transparent,
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
                  Text(
                    place.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  detail.when(
                    loading:
                        () => SizedBox(
                          height: 200,
                          child: Center(
                            child: const CircularProgressIndicator(
                              color: AppColors.cpBlue,
                            ),
                          ),
                        ),
                    error: (e, _) => Text('정보 불러오기 실패: $e'),
                    data: (data) {
                      if (data == null) return const SizedBox.shrink();
                      return Column(
                        children: [
                          PlaceDetailSection(detail: data),
                          PlaceMapView(place: place),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/long_bottom_button.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/providers/home/place_detail_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/image_slider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_detail_section.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/place_map_view.dart';

class RecommendedPlaceDetailSheet extends ConsumerStatefulWidget {
  const RecommendedPlaceDetailSheet({
    super.key,
    required this.place,
    this.scrollController,
    this.showSelectButton = true,
  });

  final HomePlace place;
  final ScrollController? scrollController;
  final bool showSelectButton;

  @override
  ConsumerState<RecommendedPlaceDetailSheet> createState() =>
      _RecommendedPlaceDetailSheetState();
}

class _RecommendedPlaceDetailSheetState
    extends ConsumerState<RecommendedPlaceDetailSheet> {
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final detail = ref.watch(placeDetailViewModelProvider);

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
                    imageUrls:
                        widget.place.thumbnail.isNotEmpty
                            ? [widget.place.thumbnail]
                            : [
                              'https://cdn.pixabay.com/photo/2017/06/24/04/37/cloud-2436676_1280.jpg',
                            ],
                    currentPage: _currentPage,
                    pageController: _pageController,
                    onPageChanged:
                        (index) => setState(() => _currentPage = index),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: detail.when(
                      loading:
                          () => SizedBox(
                            height: 200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.cpBlue,
                              ),
                            ),
                          ),
                      error: (e, _) => Text('정보 불러오기 실패: $e'),
                      data: (data) {
                        if (data == null) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            const SizedBox(height: 24),
                            PlaceDetailSection(detail: data),
                            const SizedBox(height: 24),
                            PlaceMapView(place: place),
                            const SizedBox(height: 80),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼
          if (widget.showSelectButton)
              LongBottomButton(
                onEditTap: () {
                  Navigator.pop(context, {
                    'title': place.title,
                    'lat': place.latLng.latitude,
                    'lng': place.latLng.longitude,
                    'address': place.address,
                  });
                },
                buttonText: '선택하기',
                backgroundColor: AppColors.primary[300]!,
                textColor: Colors.white,
              ),
            // ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/bottom_bar_provider.dart';
import 'package:travel_muse_app/main.dart';
import 'package:travel_muse_app/providers/plan/calendar_location_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/location_provider.dart';
import 'package:travel_muse_app/providers/user/app_user_view_model_provider.dart';
import 'package:travel_muse_app/views/home/widgets/info_banner.dart';
import 'package:travel_muse_app/views/home/widgets/recommended_places_list.dart';
import 'package:travel_muse_app/views/home/widgets/recommended_restaurants_list.dart';
import 'package:travel_muse_app/views/home/widgets/section_title.dart';
import 'package:travel_muse_app/views/home/widgets/travel_register_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref
          .read(calendarLocationViewModelProvider.notifier)
          .loadNearestUpcomingPlan();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ref.read(bottomBarProvider.notifier).state = 0;
  }

  @override
  Widget build(BuildContext context) {
    final appUserAsync = ref.watch(appUserViewModelProvider);
    final locAsync = ref.watch(locationProvider); // 위치 권한 상태

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: appUserAsync.when(
          data: (user) {
            // 권한 여부에 따라 제목 결정
            final String titleText = locAsync.when(
              data: (_) => '${user.nickname}님의 위치 기반 추천 명소예요',
              loading: () => '${user.nickname}님의 위치 기반 추천 명소예요',
              error: (_, __) => '오늘의 추천 명소예요',
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Logo.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Travelmuse',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey[800],
                            fontFamily: 'Ssangmun',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const InfoBanner(),
                  const SizedBox(height: 8),
                  Center(child: TravelRegisterButton()),
                  const SizedBox(height: 24),

                  // 수정된 제목
                  SectionTitle(title: titleText),

                  const SizedBox(height: 8),
                  const RecommendedPlacesList(),
                  const SizedBox(height: 10),

                  const SectionTitle(title: '최근 유행하는 맛집이에요'),
                  const SizedBox(height: 8),
                  const RecommendedRestaurantsList(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
          error: (e, st) => const Text('홈 화면 불러오기 실패. 앱을 재시작해 주세요.'),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

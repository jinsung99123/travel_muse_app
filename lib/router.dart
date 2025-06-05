import 'package:go_router/go_router.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/location/map_page.dart';
import 'package:travel_muse_app/views/login/login_page.dart';
import 'package:travel_muse_app/views/my_page/my_page.dart';
import 'package:travel_muse_app/views/onboarding/onboarding_page.dart';
import 'package:travel_muse_app/views/plan/place_search/place_search_page.dart';
import 'package:travel_muse_app/views/plan/schedule/schedule_page.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const SchedulePage(),
    ),
    GoRoute(
      path: '/place_search',
      builder: (context, state) => const PlaceSearchPage(),
    ),
    GoRoute(path: '/location', builder: (context, state) => const MapPage()),
    GoRoute(path: '/mypage', builder: (context, state) => const MyPage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/preference_test',
      builder: (context, state) => const PreferenceTestPage(),
    ),
  ],
);

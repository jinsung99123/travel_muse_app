import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_muse_app/firebase_options.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/location/map_page.dart';
import 'package:travel_muse_app/views/login/login_page.dart';
import 'package:travel_muse_app/views/my_page/my_page.dart';
import 'package:travel_muse_app/views/onboarding/onboarding_page.dart';
import 'package:travel_muse_app/views/plan/place_search/place_search_page.dart';
import 'package:travel_muse_app/views/plan/schedule/schedule_page.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        GoRoute(
          path: '/location',
          builder: (context, state) => const MapPage(),
        ),
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

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Travel Muse App',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

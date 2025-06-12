import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/firebase_options.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/login/login_page.dart';
import 'package:travel_muse_app/views/my_page/sheet/edit_profile_page.dart';
import 'package:travel_muse_app/views/onboarding/onboarding_page_set_profile.dart';
import 'package:travel_muse_app/views/splash/splash_page.dart';

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
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      home: OnboardingPageSetProfile(),
      // 로그인 상태에 따라 로그인/홈 분기
      // StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     final user = snapshot.data;
      //     final Widget target =
      //         user == null ? const LoginPage() : const HomePage();
      //     return SplashPage(firstPagebyLoginState: target);
      //   },
      // ),
    );
  }
}

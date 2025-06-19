import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/user/auth_view_model_provider.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/user/login/login_page.dart';
import 'package:travel_muse_app/views/user/onboarding/onboarding_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Widget nextPage = LoginPage();

      Timer(const Duration(seconds: 2), () async {
        final navigator = Navigator.of(context);
        if (ref.read(authViewModelProvider).user != null) {
          final viewmodel = ref.read(authViewModelProvider.notifier);
          await viewmodel.isUserNew();

          final updatedState = ref.read(authViewModelProvider);
          log('${updatedState.appUser == null}');

          if (updatedState.isUserNew) {
            nextPage = OnboardingPage();
          } else {
            nextPage = HomePage();
          }
        }

        unawaited(
          navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => nextPage),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        height: double.maxFinite,
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 216,
                  height: 216,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'TravelMuse',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Ssangmun',
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

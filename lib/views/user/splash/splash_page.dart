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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    final navigator = Navigator.of(context);

    Widget nextPage = const LoginPage();

    final authState = ref.read(authViewModelProvider);
    log('유저 정보가 있는가? : ${authState.user != null}');
    if (authState.user != null) {
      final viewmodel = ref.read(authViewModelProvider.notifier);
      await viewmodel.isUserNew();

      final updatedState = ref.read(authViewModelProvider);
      log('유저 문서가 있는가? : ${updatedState.isUserNew != null}');
      if (updatedState.isUserNew != null) {
        nextPage = const OnboardingPage();
      } else {
        nextPage = const HomePage();
      }
    }

    await Future.delayed(const Duration(seconds: 2));

    await navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => nextPage),
    );
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

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/auth_view_model.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/login/login_page.dart';
import 'package:travel_muse_app/views/onboarding/onboarding_page.dart';

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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 320),
          Center(
            child: Image.asset(
              'assets/images/Logo.png',
              width: 216,
              height: 216,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Text(
              'TravelMuse',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Ssangmun',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

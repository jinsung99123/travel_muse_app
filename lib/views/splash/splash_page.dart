import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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

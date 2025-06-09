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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 120),
            Image.asset(
              'assets/images/Logo.png',
              width: 216,
              height: 216,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'TravelMuse',
              style: TextStyle(fontSize: 24, fontFamily: 'Ssangmun'),
            ),
          ],
        ),
      ),
    );
  }
}

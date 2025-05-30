import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/login/widgets/sns_login_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.1),
          Text(
            'TravelMuse',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenHeight * 0.1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SnsLoginBar(
                  sns: 'Google',
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  loginFunction: () async {}, // SignWithGoogle
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

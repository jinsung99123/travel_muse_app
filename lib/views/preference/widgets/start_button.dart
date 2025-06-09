import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/preference_intro_page_2.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: CupertinoButton(
          color: const Color(0xFF15BFFD),
          borderRadius: BorderRadius.circular(10),
          child: const Text(
            '시작하기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const PreferenceIntroPage2(),
              ),
            );
          },
        ),
      ),
    );
  }
}

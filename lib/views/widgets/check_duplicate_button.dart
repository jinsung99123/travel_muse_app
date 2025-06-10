import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/edit_nickname_view_model.dart';

class DuplicateCheckButton extends ConsumerWidget {
  const DuplicateCheckButton({super.key, required this.state});

  final EditNicknameState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameViewmodel = ref.read(editNicknameViewModelProvider.notifier);
    final nicknameController = nicknameViewmodel.nicknameController;
    final input = nicknameController.text;

    return SizedBox(
      width: 113,
      height: 56,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              !state.canCheck ? Color(0xFFE9EBEB) : Color(0xFF48CDFD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          log('중복확인 버튼 누름');
          if (!state.canCheck) return;

          await nicknameViewmodel.checkCanUseNickname(input);
        },
        child: Text(
          '중복 확인',
          style: TextStyle(
            color: !state.canCheck ? Color(0xFFB3B9BC) : Colors.white,
            fontSize: 18,
            fontFamily: 'Pretendard',
            height: 0.08,
          ),
        ),
      ),
    );
  }
}

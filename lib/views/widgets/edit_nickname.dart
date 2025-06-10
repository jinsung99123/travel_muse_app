import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/viewmodels/edit_nickname_view_model.dart';
import 'package:travel_muse_app/views/widgets/check_duplicate_button.dart';

class EditNickname extends ConsumerWidget {
  const EditNickname({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editNicknameViewModelProvider);
    final showAsError = state.isValid == false || state.isDuplicate == true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('닉네임', style: AppTextStyles.onboardingSectionTitle),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    // 텍스트폼필드
                    child: TextFormField(
                      controller: controller,
                      onChanged: (value) {
                        ref
                            .read(editNicknameViewModelProvider.notifier)
                            .checkInputChanged(value);
                      },
                      textAlignVertical: TextAlignVertical.center,
                      // 높이, 내부 텍스트 정렬
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        enabledBorder: AppOtherStyles.unfocusedBorder,
                        focusedBorder: AppOtherStyles.focusedBorder,
                        isDense: true,
                        hintText: '닉네임', // TODO: 유저 기존 닉네임 연결, 없을 시 표시 X
                        errorText: null,
                        helperText: null,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  DuplicateCheckButton(state: state),
                ],
              ),
            ),
          ),
          SizedBox(
            child: Text(
              state.message ?? '',
              style:
                  showAsError
                      ? AppTextStyles.errorText
                      : AppTextStyles.helperText,
            ),
          ),
        ],
      ),
    );
  }
}

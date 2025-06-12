import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/views/onboarding/widgets/check_duplicate_button.dart';

class EditNickname extends ConsumerWidget {
  const EditNickname({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final showAsError =
        state.isNicknameValid == false || state.isNicknameDuplicate == true;

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
                      onChanged: (value) {
                        ref
                            .read(profileViewModelProvider.notifier)
                            .checkNicknameChanged(value);
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
                        hintText: state.currentNickname ?? '',
                        errorText: null,
                        helperText: null,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  DuplicateCheckButton(),
                ],
              ),
            ),
          ),
          SizedBox(
            child: Text(
              state.nicknameMessage ?? '',
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

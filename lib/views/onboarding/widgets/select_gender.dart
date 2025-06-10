import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';

class SelectGender extends ConsumerWidget {
  const SelectGender({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final viewmodel = ref.read(profileViewModelProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('성별', style: AppTextStyles.onboardingSectionTitle),
          SizedBox(height: 8),
          Row(
            children: [
              optionBox(value: '남성', state: state, viewmodel: viewmodel),
              SizedBox(width: 16),
              optionBox(value: '여성', state: state, viewmodel: viewmodel),
            ],
          ),
        ],
      ),
    );
  }

  Widget optionBox({
    required String value,
    required ProfileState state,
    required ProfileViewModel viewmodel,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          viewmodel.selectGender(value);
          viewmodel.isGenderValid();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 56,
          decoration:
              state.gender == value
                  ? AppOtherStyles.selectedBox
                  : AppOtherStyles.unselectedBox,
          child: Center(
            child: Text(
              value,
              style:
                  state.gender == value
                      ? AppTextStyles.selectedBoxText
                      : AppTextStyles.unselectedBoxText,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';

class SelectGender extends ConsumerWidget {
  const SelectGender({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final viewmodel = ref.read(profileViewModelProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('성별', style: AppTextStyles.sectionTitle),
        Row(
          children: [
            optionBox(value: '남성', state: state, viewmodel: viewmodel),
            SizedBox(width: 16),
            optionBox(value: '여성', state: state, viewmodel: viewmodel),
          ],
        ),
      ],
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
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFF98A0A4),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              value,
              style:
                  state.gender == value
                      ? TextStyle(
                        // 선택 시
                        color: Color(0xFF7C878C),
                        fontSize: 18,
                        fontFamily: 'Pretendard',
                        height: 0.08,
                      )
                      : TextStyle(
                        // 미선택 시
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

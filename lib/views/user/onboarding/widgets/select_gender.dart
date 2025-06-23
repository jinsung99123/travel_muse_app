import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/views/user/onboarding/widgets/option_box.dart';

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
              OptionBox(value: '남성', state: state, viewmodel: viewmodel),
              SizedBox(width: 16),
              OptionBox(value: '여성', state: state, viewmodel: viewmodel),
            ],
          ),
        ],
      ),
    );
  }
}

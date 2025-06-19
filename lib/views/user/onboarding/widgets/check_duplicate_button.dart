import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/views/user/onboarding/widgets/duplicate_button_themes.dart';

class DuplicateCheckButton extends ConsumerWidget {
  const DuplicateCheckButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final viewmodel = ref.read(profileViewModelProvider.notifier);

    return SizedBox(
      width: 115,
      height: 56,
      child: GestureDetector(
        onTap: () async {
          if (state.nicknameInput == null) return;

          await viewmodel.checkCanUseNickname();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: DuplicateButtonThemes().getButtonStyle(state.buttonState),
          child: Center(
            child: DuplicateButtonThemes().getText(state.buttonState),
          ),
        ),
      ),
    );
  }
}

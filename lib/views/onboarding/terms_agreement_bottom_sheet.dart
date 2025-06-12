import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/viewmodels/terms_agreement_view_model.dart';
import 'package:travel_muse_app/views/onboarding/widgets/terms_agree_all.dart';
import 'package:travel_muse_app/views/onboarding/widgets/terms_agreement_title.dart';
import 'package:travel_muse_app/views/onboarding/widgets/terms_list.dart';
import 'package:travel_muse_app/views/preference/preference_intro_page_2.dart';
import 'package:travel_muse_app/views/widgets/next_button.dart';

class TermsAgreementBottomSheet extends ConsumerWidget {
  const TermsAgreementBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsKeys =
        ref.watch(termsAgreementViewModelProvider.notifier).termsKeys;
    final allRequiresAgreed =
        ref.watch(termsAgreementViewModelProvider).allRequiresAgreed;
    final viewmodel = ref.read(profileViewModelProvider.notifier);

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),

        child: Wrap(
          children: [
            TermsAgreementTitle(),
            TermsAgreeAll(),
            TermsList(termsKeys: termsKeys),
            Padding(
              padding: const EdgeInsets.only(bottom: 34),
              child: NextButton(
                text: '가입 완료',
                isActivated: allRequiresAgreed,
                onPressed: () async {
                  if (allRequiresAgreed) {
                    await viewmodel.updateProfile();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PreferenceIntroPage2()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

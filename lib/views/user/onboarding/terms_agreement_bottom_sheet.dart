import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/providers/user/terms_view_model_provider.dart';
import 'package:travel_muse_app/providers/user/user_agreement_view_model_provider.dart';
import 'package:travel_muse_app/views/preference/preference_intro_page_2.dart';
import 'package:travel_muse_app/views/user/onboarding/widgets/terms_agree_all.dart';
import 'package:travel_muse_app/views/user/onboarding/widgets/terms_agreement_title.dart';
import 'package:travel_muse_app/views/user/onboarding/widgets/terms_list.dart';
import 'package:travel_muse_app/views/widgets/user_next_button.dart';

class TermsAgreementBottomSheet extends ConsumerWidget {
  const TermsAgreementBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreementState = ref.watch(userAgreementViewModelProvider);
    final agreementViewmodel = ref.read(
      userAgreementViewModelProvider.notifier,
    );

    ref.listen(termsViewModelProvider, (_, next) {
      next.whenData((termsList) {
        final agreementList =
            ref.read(userAgreementViewModelProvider).agreementList;
        if (agreementList.isEmpty) {
          agreementViewmodel.setUserAgreementList(termsList);
        }
      });
    });

    final profileViewmodel = ref.read(profileViewModelProvider.notifier);

    return Container(
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
          TermsList(),
          Padding(
            padding: const EdgeInsets.only(bottom: 34),
            child: UserNextButton(
              text: '가입 완료',
              isActivated: agreementState.isAllRequiredAgreed,
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (agreementState.isAllRequiredAgreed) {
                  await profileViewmodel.updateProfile();
                  await agreementViewmodel.uploadUserAgreements();
                  unawaited(
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => PreferenceIntroPage2()),
                      (route) => false,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

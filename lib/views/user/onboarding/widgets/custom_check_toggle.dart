import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/user/user_agreement_view_model_provider.dart';

class CustomCheckToggle extends ConsumerWidget {
  const CustomCheckToggle({super.key, this.termId});

  final String? termId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreementState = ref.watch(userAgreementViewModelProvider);
    bool isAgreed =
        termId == null
            ? agreementState.isAllAgreed
            : agreementState.agreementList
                .firstWhere((e) => e.termId == termId)
                .agreed;

    return GestureDetector(
      onTap: () {
        isAgreed = !isAgreed;
        if (termId == null) {
          ref.read(userAgreementViewModelProvider.notifier).toggleAllAgreed();
        } else {
          ref
              .read(userAgreementViewModelProvider.notifier)
              .toggleAgreedByTermId(termId: termId!, agreeOnly: false);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          width: 24,
          height: 24,
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: isAgreed ? AppColors.primary[300] : AppColors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(500),
            ),
          ),
          child: SvgPicture.asset(
            'assets/icons/check.svg',
            width: 10.5,
            height: 9.25,
          ),
        ),
      ),
    );
  }
}

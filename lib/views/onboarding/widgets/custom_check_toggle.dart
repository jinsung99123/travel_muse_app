import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/viewmodels/terms_agreement_view_model.dart';

class CustomCheckToggle extends ConsumerWidget {
  const CustomCheckToggle({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreementState =
        ref.watch(termsAgreementViewModelProvider).agreementState;

    final termsKeys =
        ref.watch(termsAgreementViewModelProvider.notifier).termsKeys; // 약관 리스트
    final termKey = termsKeys[index];

    final isSelected = agreementState[termKey]; // 선택된 약관의 상태

    return GestureDetector(
      onTap: () {
        ref
            .read(termsAgreementViewModelProvider.notifier)
            .toggleAgreement(termKey);
      },
      child: Container(
        width: 24,
        height: 24,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: isSelected! ? AppColors.primary[300] : AppColors.grey[300],
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/constants/markdown_style_sheet.dart';
import 'package:travel_muse_app/models/user/terms_model.dart';
import 'package:travel_muse_app/providers/user/user_agreement_view_model_provider.dart';
import 'package:travel_muse_app/views/user/onboarding/widgets/duplicate_button_themes.dart';

class TermsDetailBottomSheet extends ConsumerWidget {
  const TermsDetailBottomSheet({super.key, required this.term});

  final Terms term;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: screenHeight * 0.75,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 28),
            Expanded(
              child: ListView(
                children: [
                  Markdown(
                    data: term.content,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    softLineBreak: true,
                    styleSheet: markdownStyle,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                ref
                    .read(userAgreementViewModelProvider.notifier)
                    .toggleAgreedByTermId(
                      termId: term.id,
                      agreeOnly: true,
                    );
                Navigator.pop(context);
              },
              child: Container(
                height: 56,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: DuplicateButtonThemes.availableBoxStyle,
                child: Center(
                  child: Text(
                    '동의하기',
                    style: AppTextStyles.avaliableButtonText,
                  ),
                ),
              ),
            ),
            SizedBox(height: 34),
          ],
        ),
      ),
    );
  }
}

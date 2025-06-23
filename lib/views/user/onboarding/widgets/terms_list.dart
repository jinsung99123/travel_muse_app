import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/models/user/terms_model.dart';
import 'package:travel_muse_app/providers/user/terms_view_model_provider.dart';
import 'package:travel_muse_app/views/user/onboarding/terms_detail_bottom_sheet.dart';
import 'package:travel_muse_app/views/user/onboarding/widgets/custom_check_toggle.dart';

class TermsList extends ConsumerWidget {
  const TermsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsListAsync = ref.watch(termsViewModelProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: termsListAsync.when(
        data:
            (termsList) => ListView.separated(
              shrinkWrap: true,
              itemCount: termsList.length,
              itemBuilder:
                  (context, index) => SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        CustomCheckToggle(termId: termsList[index].id),
                        SizedBox(width: 12),
                        Text(
                          '''${termsList[index].isRequired ? '(필수)' : '(선택)'} ${termsList[index].title}''',
                          style: AppTextStyles.termsText,
                        ),
                        Spacer(),
                        showDetailTextButton(
                          context: context,
                          term: termsList[index],
                        ),
                      ],
                    ),
                  ),
              separatorBuilder: (context, index) => SizedBox(height: 12),
            ),
        loading: () => CircularProgressIndicator(),
        error: (e, _) => Text('약관 불러오기 실패: $e'),
      ),
    );
  }

  Widget showDetailTextButton({
    required BuildContext context,
    required Terms term,
  }) {
    return term.content.isNotEmpty
        ? GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return TermsDetailBottomSheet(term: term);
              },
            );
          },
          child: Text(
            '보기',
            style: TextStyle(
              color: AppColors.grey[300],
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
            ),
          ),
        )
        : SizedBox.shrink();
  }
}

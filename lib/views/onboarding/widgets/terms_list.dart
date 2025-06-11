import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/views/onboarding/widgets/custom_check_toggle.dart';

class TermsList extends StatelessWidget {
  const TermsList({super.key, required this.termsKeys});

  final List<String> termsKeys;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: termsKeys.length - 1,
        itemBuilder:
            (context, index) => Row(
              children: [
                CustomCheckToggle(index: index + 1),
                SizedBox(width: 8),
                Text(termsKeys[index + 1], style: AppTextStyles.termsText),
              ],
            ),
        separatorBuilder: (context, index) => SizedBox(height: 12),
      ),
    );
  }
}

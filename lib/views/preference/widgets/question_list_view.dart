import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/widgets/option_button.dart';

class QuestionListView extends StatelessWidget {
  const QuestionListView({
    super.key,
    required this.options,
    required this.onOptionSelected,
    required this.selectedOption,
  });

  final List<String> options;
  final String? selectedOption;
  final void Function(String) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedOption;
          return OptionButton(
            text: option,
            isSelected: isSelected,
            onPressed: () => onOptionSelected(option),
          );
        },
      ),
    );
  }
}

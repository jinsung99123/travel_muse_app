import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/widgets/option_button.dart';

class QuestionListView extends StatelessWidget {

  const QuestionListView({
    super.key,
    required this.options,
    required this.onOptionSelected,
  });
  final List<String> options;
  final void Function(String) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return OptionButton(
            text: option,
            onPressed: () => onOptionSelected(option),
          );
        },
      ),
    );
  }
}

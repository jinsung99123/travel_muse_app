import 'package:flutter/material.dart';

void showReasonDialog(
  BuildContext context,
  List<String> reasonCodes,
  List<String?> reasonTexts,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('신고 사유'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: reasonCodes.length,
          itemBuilder: (_, index) {
            final code = reasonCodes[index];
            final text = reasonTexts[index] ?? '';
            return ListTile(
              title: Text(code),
              subtitle: text.isNotEmpty ? Text(text) : null,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}

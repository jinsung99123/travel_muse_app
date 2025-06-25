import 'package:flutter/material.dart';

void showReportReasonDialog(BuildContext context, Function(String reasonCode, String? reasonText) onSubmit) {
  final List<String> reasons = ['광고/스팸', '부적절한 콘텐츠', '욕설/혐오 표현', '기타'];
  String selectedReason = reasons[0];
  TextEditingController customReasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('신고 사유를 선택하세요'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...reasons.map((reason) => RadioListTile<String>(
                      title: Text(reason),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() => selectedReason = value!);
                      },
                    )),
                if (selectedReason == '기타')
                  TextField(
                    controller: customReasonController,
                    decoration: const InputDecoration(hintText: '사유를 입력하세요'),
                  ),
              ],
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final reasonText = selectedReason == '기타' ? customReasonController.text : null;
              onSubmit(selectedReason, reasonText);
            },
            child: const Text('신고하기'),
          ),
        ],
      );
    },
  );
}

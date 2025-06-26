import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

void showReportReasonDialog(
  BuildContext context,
  Function(String reasonCode, String? reasonText) onSubmit,
) {
  final List<String> reasons = ['광고 및 스팸', '부적절한 콘텐츠', '욕설 및 혐오 표현', '기타'];
  String selectedReason = reasons[0];
  TextEditingController customReasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(10), 
          ),
          width: 286,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '신고 사유를 선택해주세요',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...reasons.map((reason) {
                      final isSelected = selectedReason == reason;
                      return GestureDetector(
                        onTap: () => setState(() => selectedReason = reason),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isSelected
                                          ? AppColors.primary[400]
                                          : AppColors.grey[100],
                                ),
                                child: Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                reason,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Pretendard',
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (selectedReason == '기타') ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: customReasonController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: '사유를 입력해주세요',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text(
                              '취소',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Pretendard',
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              final reasonText =
                                  selectedReason == '기타'
                                      ? customReasonController.text
                                      : null;
                              onSubmit(selectedReason, reasonText);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text(
                              '완료',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Pretendard',
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

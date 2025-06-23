import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';

///신고하기 테스트 화면입니다.
class ReportTest extends ConsumerWidget{
  const ReportTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(reportViewModelProvider.notifier).submit(
              targetType: 'post',
              targetId: 'test_post_123',
              reporterId: 'user_test_001',
              targetOwnerId: 'user_target_001',
              reasonCode: 'SPAM',
              reasonText: '테스트 신고입니다',
            );
          },
          child: Text('신고 테스트'),
        ),
      ),
    );
  }
}
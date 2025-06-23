import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/user/app_user_view_model_provider.dart';

class UserInfo extends ConsumerStatefulWidget {
  const UserInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInfoState();
}

class _UserInfoState extends ConsumerState<UserInfo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(appUserViewModelProvider.notifier).fetchAppUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appUserAsync = ref.watch(appUserViewModelProvider);

    return SizedBox(
      child: appUserAsync.when(
        data:
            (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '회원 정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text('생년월일: ${data.birthDate ?? ''}'),
                Text('성별: ${data.gender ?? ''}'),
              ],
            ),
        loading: () => CircularProgressIndicator(),
        error: (e, _) => Text('프로필 정보 불러오기 실패: $e'),
      ),
    );
  }
}

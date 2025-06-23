import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/user/app_user_view_model_provider.dart';

class AccountInfo extends ConsumerStatefulWidget {
  const AccountInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountInfoState();
}

class _AccountInfoState extends ConsumerState<AccountInfo> {
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
                  '계정 정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text(data.loginProvider ?? ''),
                Text(data.loginEmail ?? ''),
              ],
            ),
        loading: () => CircularProgressIndicator(),
        error: (e, _) => Text('프로필 정보 불러오기 실패: $e'),
      ),
    );
  }
}

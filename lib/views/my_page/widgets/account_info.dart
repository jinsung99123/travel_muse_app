import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: AppColors.grey[50]!)),
        ),
        child: appUserAsync.when(
          data:
              (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '계정 정보',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '로그인',
                        style: TextStyle(
                          color: AppColors.grey[600],
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      Text(
                        loginProviderFormatter(data.loginProvider),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '이메일',
                        style: TextStyle(
                          color: AppColors.grey[600],
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: screenWidth * 0.7,
                        child: Text(
                          data.loginEmail ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          loading: () => CircularProgressIndicator(),
          error: (e, _) => Text('프로필 정보 불러오기 실패: $e'),
        ),
      ),
    );
  }

  String loginProviderFormatter(String? provider) {
    if (provider == null) return '';
    String providerName = provider.split('.').first;
    return '$providerName 로그인';
  }
}

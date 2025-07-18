import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/user/terms_view_model_provider.dart';
import 'package:travel_muse_app/views/user/onboarding/terms_detail_page.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class ServiceTermPage extends ConsumerWidget {
  const ServiceTermPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsListAsync = ref.watch(termsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 약관', style: TextStyle()),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
      ),
      body: termsListAsync.when(
        data:
            (data) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final term = data[index];
                  return GestureDetector(
                    onTap:
                        term.content.isNotEmpty
                            ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TermsDetailPage(term: term),
                                ),
                              );
                            }
                            : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: AppColors.grey[50]!,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              term.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                          ),
                          term.content.isNotEmpty
                              ? Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.grey[600],
                              )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        error: (error, st) => Center(child: CircularProgressIndicator()),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

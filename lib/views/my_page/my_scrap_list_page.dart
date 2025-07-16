import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/providers/home/scrap_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';
import 'package:travel_muse_app/views/my_page/widgets/confirm_dialog.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class MyScrapListPage extends ConsumerWidget {
  const MyScrapListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(scrapListViewModelProvider.notifier).load();
    final state = ref.watch(scrapListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('에러 발생: $err')),
        data: (places) {
          if (places.isEmpty) {
            return const _EmptyScrapView(); // 스크랩 없을 때
          }

          return ListView.separated(
            itemCount: places.length,
            separatorBuilder:
                (_, __) => Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColors.grey[200],
                ),
            itemBuilder: (context, index) {
              final place = places[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecommendedPlaceDetailPage(place: place),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          place.thumbnail,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              place.address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              place.category,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        iconSize: 24,
                        icon: Icon(
                          Icons.bookmark,
                          color: AppColors.primary[300],
                        ),
                        onPressed: () async {
                          final confirm = await _showDeleteDialog(context);
                          if (confirm != true) return;

                          await ref
                              .read(scrapListViewModelProvider.notifier)
                              .remove(place);

                          CustomToast.show(
                            context: context,
                            message: '북마크에서 삭제했습니다.',
                            duration: const Duration(seconds: 2),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<bool?> _showDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => const ConfirmDialog(
          title: '스크랩을 해제하시겠습니까?',
          description: '스크랩을 삭제하고 후에는 되돌릴 수 없어요',
        ),
  );
}

class _EmptyScrapView extends StatelessWidget {
  const _EmptyScrapView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text(
            '스크랩한 장소가 없어요',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

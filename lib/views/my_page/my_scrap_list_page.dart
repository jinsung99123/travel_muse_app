import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/home/scrap_provider.dart';

class MyScrapListPage extends ConsumerWidget {
  const MyScrapListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(scrapListViewModelProvider.notifier).load();
    final state = ref.watch(scrapListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
        centerTitle: false,
        elevation: 0,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('에러 발생: $err')),
        data:
            (places) => ListView.separated(
              itemCount: places.length,
              separatorBuilder:
                  (_, __) => const Divider(height: 1, thickness: 0.5),
              itemBuilder: (context, index) {
                final place = places[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              place.address,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${place.category}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark, color: Colors.blue),
                        onPressed: () {
                          ref
                              .read(scrapListViewModelProvider.notifier)
                              .remove(place);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('스크랩이 해제되었어요'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}

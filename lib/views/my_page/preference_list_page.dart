import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_page_list_item.dart';

class PreferenceListPage extends ConsumerStatefulWidget {
  const PreferenceListPage({super.key});

  @override
  ConsumerState<PreferenceListPage> createState() => _PreferenceListPageState();
}

class _PreferenceListPageState extends ConsumerState<PreferenceListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(profileViewModelProvider.notifier).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    final testId = profileState.testId;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '나의 성향',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              testId.isEmpty
                  ? Center(
                    child: Text('여행 성향 테스트 결과가 없습니다.'),
                  ) // TODO: 여행 성향 검사 하러가기 버튼
                  : ListView.builder(
                    itemCount: testId.length,
                    itemBuilder: (context, index) {
                      return MyPageListItem(
                        dbList: testId,
                        index: index,
                        onTap: () {},
                      );
                    },
                  ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

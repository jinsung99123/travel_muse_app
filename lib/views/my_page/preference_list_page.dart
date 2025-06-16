import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';
import 'package:travel_muse_app/providers/preference_test_provider.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_page_list_item.dart';
import 'package:travel_muse_app/views/preference/preference_loading_page.dart';

class PreferenceListPage extends ConsumerStatefulWidget {
  const PreferenceListPage({super.key});

  @override
  ConsumerState<PreferenceListPage> createState() => _PreferenceListPageState();
}

class _PreferenceListPageState extends ConsumerState<PreferenceListPage> {
  List<PreferenceTest> _tests = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(profileViewModelProvider.notifier).fetchUserProfile();
      final tests =
          await ref
              .read(preferenceTestViewModelProvider.notifier)
              .fetchTestsByUserId();
      setState(() {
        _tests = tests;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              _tests.isEmpty
                  ? Center(
                    child: Text('여행 성향 테스트 결과가 없습니다.'),
                  ) // TODO: 여행 성향 검사 하러가기 버튼
                  : ListView.builder(
                    itemCount: _tests.length,
                    itemBuilder: (context, index) {
                      return MyPageListItem(
                        itemTitle: _tests[index].result['type'] ?? '알 수 없음',
                        index: index,
                        onTap: () {
                          // preferenceTestResultViewPage
                        },
                      );
                    },
                  ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

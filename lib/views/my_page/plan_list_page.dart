import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_page_list_item.dart';

class PlanListPage extends ConsumerStatefulWidget {
  const PlanListPage({super.key});

  @override
  ConsumerState<PlanListPage> createState() => _PlanListPageState();
}

class _PlanListPageState extends ConsumerState<PlanListPage> {
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
    final planId = profileState.planId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 여행', style: AppTextStyles.appBarTitle),
        centerTitle: false,
      ),
      body: SafeArea(
        child:
            planId.isEmpty
                ? Center(child: Text('여행 일정이 없습니다.'))
                : ListView.builder(
                  itemCount: planId.length,
                  itemBuilder: (context, index) {
                    return MyPageListItem(
                      dbList: planId,
                      index: index,
                      onTap: () {},
                    );
                  },
                ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

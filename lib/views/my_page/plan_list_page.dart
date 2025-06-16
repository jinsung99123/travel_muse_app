import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/core/format_month_day.dart';
import 'package:travel_muse_app/core/format_region.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/schedule_provider.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/viewmodels/schedule_view_model.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_page_list_item.dart';
import 'package:travel_muse_app/views/plan/schedule/schedule_page.dart';

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
      await ref.read(scheduleViewModelProvider.notifier).fetchSavedPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final ScheduleState? plans = ref.watch(scheduleViewModelProvider).value;
    final savedPlans = plans != null ? plans.savedPlans : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 여행', style: AppTextStyles.appBarTitle),
        centerTitle: false,
      ),
      body: SafeArea(
        child:
            savedPlans.isEmpty
                ? Center(child: Text('여행 일정이 없습니다.'))
                : ListView.builder(
                  itemCount: savedPlans.length,
                  itemBuilder: (context, index) {
                    return MyPageListItem(
                      itemTitle:
                          '${formatMonthDay(savedPlans[index].startDate)}~${formatMonthDay(savedPlans[index].startDate)} ${formatRegion(savedPlans[index].region)} 여행',
                      index: index,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SchedulePage(
                                  userId: user!.uid,
                                  planId: savedPlans[index].planId,
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

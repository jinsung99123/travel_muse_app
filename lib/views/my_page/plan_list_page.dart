import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/plan/schedule/schedule_provider.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/utills/format_month_day.dart';
import 'package:travel_muse_app/utills/format_region.dart';
import 'package:travel_muse_app/viewmodels/plan/schedule_view_model.dart';
import 'package:travel_muse_app/views/my_page/widgets/delete_plan_dialog.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_page_list_item.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/schedule_page.dart';

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

  Future<bool> _showDeleteDialog(String planId) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const DeletePlanDialog(),
    );

    if (result == true) {
      await ref.read(scheduleViewModelProvider.notifier).deletePlanById(planId);
      await ref.read(scheduleViewModelProvider.notifier).fetchSavedPlans();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('일정이 삭제되었습니다.')));
      }
      return true;
    }

    return false;
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
                ? const Center(child: Text('여행 일정이 없습니다.'))
                : ListView.builder(
                  itemCount: savedPlans.length,
                  itemBuilder: (context, index) {
                    final plan = savedPlans[index];
                    return Dismissible(
                      key: Key(plan.planId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: AppColors.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          '삭제',
                          style: TextStyle(color: AppColors.white,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          fontSize: 16
                          ),
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await _showDeleteDialog(plan.planId);
                      },
                      child: MyPageListItem(
                        itemTitle:
                            '${formatMonthDay(plan.startDate)}~${formatMonthDay(plan.endDate)} ${formatRegion(plan.region)} 여행',
                        index: index,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SchedulePage(
                                    userId: user!.uid,
                                    planId: plan.planId,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

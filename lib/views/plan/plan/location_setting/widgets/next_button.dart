import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/plan/calendar_location_provider.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/district_setting_page.dart';

class NextButton extends ConsumerWidget {
  const NextButton({
    super.key,
    required this.selectedIndex,
    required this.provinces,
  });

  final int? selectedIndex;
  final List<String> provinces;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedIndex == null ? Colors.grey : AppColors.primary[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed:
            selectedIndex == null
                ? null
                : () {
                  final selectedRegion = provinces[selectedIndex!];
                  ref
                      .read(calendarLocationViewModelProvider.notifier)
                      .setRegion(selectedRegion);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => DistrictSettingPage(
                            selectedProvince: selectedRegion,
                          ),
                    ),
                  );
                },
        child: const Text(
          '다음',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

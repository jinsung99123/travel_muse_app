import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class TagBar extends StatelessWidget {
  const TagBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: 34,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder:
                    (context, index) => Container(
                      width: 72,
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFF48CDFD),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => SizedBox(width: 8),
                itemCount: 5,
              ),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/chevron-down.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.secondary[400]!,
                  BlendMode.srcATop,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//  (context, index) => postsAsync.when(data: (data) => , loading: () => ,error: (e, st) => ,),
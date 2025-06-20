import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class DayTabBar extends StatelessWidget {
  const DayTabBar({
    required this.controller,
    required this.days,
    super.key,
  });

  final TabController controller;
  final List<String> days;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: AppColors.grey[50],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.black,
            unselectedLabelColor: AppColors.grey[300],
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 17),
            indicator: CustomUnderlineTabIndicator(
              indicatorWidth: 55,
              borderSide: BorderSide(
                width: 2.0,
                color: AppColors.primary[400]!,
              ),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 0),
            tabs: days
                .map(
                  (d) => SizedBox(
                    height: 65,
                    width: 85,
                    child: Tab(text: d),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class CustomUnderlineTabIndicator extends Decoration {
  const CustomUnderlineTabIndicator({
    required this.indicatorWidth,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.blue),
  });

  final double indicatorWidth;
  final BorderSide borderSide;


  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomUnderlinePainter(this, onChanged);
  }
}

class _CustomUnderlinePainter extends BoxPainter {
  _CustomUnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);
      
  final CustomUnderlineTabIndicator decoration;


  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    if (config.size == null) return;

    final paint = decoration.borderSide.toPaint();
    final rect = offset & config.size!;
    final dx = (rect.width - decoration.indicatorWidth) / 2;

    final underlineRect = Rect.fromLTWH(
      rect.left + dx,
      rect.bottom - 15,
      decoration.indicatorWidth,
      decoration.borderSide.width,
    );

    canvas.drawRect(underlineRect, paint);
  }
}

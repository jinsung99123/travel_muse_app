import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

const double bulletSize = 12;      // 바깥 원 지름
const double lineThickness = 1;

class DottedLineVertical extends StatelessWidget {
  const DottedLineVertical({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: lineThickness,
      height: height,
      child: DottedLine(
        direction: Axis.vertical,
        lineLength: height,
        lineThickness: lineThickness,
        dashLength: 4,
        dashGapLength: 4,
        dashColor: AppColors.grey[100]!,
      ),
    );
  }
}

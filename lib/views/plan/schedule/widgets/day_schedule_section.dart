import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/bullet.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/dotted_line_vertical.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/schedule_place_card.dart';

const double _cardHeight = 100;

class DayScheduleSection extends StatefulWidget {
  const DayScheduleSection({
    super.key,
    required this.dayIndex,
    required this.dayLabel,
    required this.schedules,
    required this.isEditing,
    required this.onReorder,
    required this.onAddPlace,
    required this.onRemovePlace,
  });

  final int dayIndex;
  final String dayLabel;
  final List<Map<String, String>> schedules;
  final bool isEditing;
  final void Function(int dayIndex, int oldIndex, int newIndex) onReorder;
  final void Function(int dayIndex) onAddPlace;
  final void Function(int dayIndex, int placeIndex) onRemovePlace;

  @override
  State<DayScheduleSection> createState() => _DayScheduleSectionState();
}

class _DayScheduleSectionState extends State<DayScheduleSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = true;
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<double> _factor = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    _ctrl.value = 1; // 처음엔 펼친 상태
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //타임라인 열 
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Bullet(),
              // 펼친 상태에서만 점선 길이
              SizedBox(
                height: _expanded ? _contentHeight : 0,
                child: DottedLineVertical(
                  height: _expanded ? _contentHeight : 0,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // 콘텐츠 열
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //헤더 - 탭해서 토글
                InkWell(
                  onTap: _toggle,
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      Text(
                        'Day ${widget.dayIndex + 1}  ${widget.dayLabel}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.grey[600],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                //접기/펼치기 애니메이션
                SizeTransition(
                  sizeFactor: _factor,
                  axisAlignment: -1,
                  child: Column(
                    children: [
                      _buildCardList(),
                      widget.schedules.isEmpty
                          ? _buildEmptyView()
                          : Center(child: _addBtn()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardList() => ReorderableListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: widget.schedules.length,
    onReorder:
        widget.isEditing
            ? (o, n) => widget.onReorder(widget.dayIndex, o, n)
            : (_, __) {},
    buildDefaultDragHandles: false,
    itemBuilder: (context, i) {
      final place = widget.schedules[i];
      return Container(
        key: ValueKey('${widget.dayIndex}-$i'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ReorderableDragStartListener(
                index: i,
                enabled: widget.isEditing,
                child: SchedulePlaceCard(
                  index: i + 1,
                  place: place,
                  showHandle: widget.isEditing,
                ),
              ),
            ),
            if (widget.isEditing)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(color: AppColors.grey[500]!),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(22, 22),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => widget.onRemovePlace(widget.dayIndex, i),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: AppColors.grey[500],
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );

  Widget _buildEmptyView() => Center(
    child: Column(
      children: [
        const SizedBox(height: 16),
        Text(
          '아직 추가된 일정이 없어요',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey[400],
            fontFamily: 'Pretendard',
          ),
        ),
        const SizedBox(height: 6),
        _addBtn(),
      ],
    ),
  );

  Widget _addBtn() => IconButton(
    splashRadius: 22,
    iconSize: 26,
    color: AppColors.cpBlue,
    onPressed: () => widget.onAddPlace(widget.dayIndex),
    icon: const Icon(Icons.add_circle_rounded),
  );

  // 헤더 밑 카드/빈뷰 총 높이
  double get _contentHeight {
    if (widget.schedules.isEmpty) return 110; // 빈 문구+버튼 예상치
    return widget.schedules.length * (_cardHeight + 8);
  }
}

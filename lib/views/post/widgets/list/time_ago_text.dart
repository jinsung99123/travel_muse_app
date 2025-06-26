import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/utills/format_time_ago.dart';

class TimeAgoText extends StatefulWidget {
  const TimeAgoText({super.key, required this.createdAt});
  final Timestamp createdAt;

  @override
  State<TimeAgoText> createState() => _TimeAgoTextState();
}

class _TimeAgoTextState extends State<TimeAgoText> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      FormatTimeAgo.formatTimeAgo(now: DateTime.now(), createdAt: widget.createdAt),
      style: AppTextStyles.postListContent,
    );
  }
}

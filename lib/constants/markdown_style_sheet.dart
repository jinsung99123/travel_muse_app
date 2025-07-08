import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

MarkdownStyleSheet markdownStyle = MarkdownStyleSheet(
  h1: TextStyle(
    fontSize: 24,
    height: 1.5,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  ),
  h2: TextStyle(
    fontSize: 20,
    color: AppColors.grey[700],
    height: 1.5,
    fontWeight: FontWeight.bold,
  ),
  p: TextStyle(fontSize: 16, height: 1.5, color: AppColors.grey[600]),
  pPadding: EdgeInsets.only(bottom: 16),
  strong: TextStyle(fontWeight: FontWeight.bold),
  listBullet: TextStyle(fontSize: 16),
  code: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    backgroundColor: AppColors.grey[100],
  ),
  horizontalRuleDecoration: BoxDecoration(
    border: Border(
      top: BorderSide(color: AppColors.grey[300]!, width: 0.5),
    ),
  ),
);

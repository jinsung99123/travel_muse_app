import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void setupEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorSize = 45.0
    ..radius = 12.0
    ..backgroundColor = Colors.white
    ..indicatorColor = Color(0xFF4AC6FF)
    ..progressColor = Color(0xFF4AC6FF)
    ..textColor = Color(0xFF222222)
    ..textStyle = const TextStyle(
      color: Color(0xFF222222),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    )
    ..maskColor = Colors.black.withOpacity(0.15)
    ..boxShadow = [
      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
    ]
    ..userInteractions = false
    ..dismissOnTap = false;
}

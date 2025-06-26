import 'package:cloud_firestore/cloud_firestore.dart';

/// 시작일(start)과 종료일(end)을 받아 여행일수를 계산한다.
/// - Timestamp 또는 DateTime 모두 지원
/// - 동일 날짜도 1일로 계산
int calculateTripDays(dynamic start, dynamic end) {
  DateTime? startDate;
  DateTime? endDate;

  if (start is Timestamp) {
    startDate = start.toDate();
  } else if (start is DateTime) {
    startDate = start;
  }

  if (end is Timestamp) {
    endDate = end.toDate();
  } else if (end is DateTime) {
    endDate = end;
  }

  if (startDate == null || endDate == null) return 1;

  return endDate.difference(startDate).inDays + 1;
}

// 여행 일수 계산 함수
int getTripDays(DateTime start, DateTime end) {
  return end.difference(start).inDays + 1;
}

// 버튼에 보여줄 텍스트 생성 함수
String getButtonText(DateTime? startDay, DateTime? endDay) {
  if (startDay == null) {
    return '다음';
  }

  final actualEndDay = endDay ?? startDay;

  final startStr =
      '${startDay.year}.${startDay.month.toString().padLeft(2, '0')}.${startDay.day.toString().padLeft(2, '0')}';
  final endStr =
      '${actualEndDay.year}.${actualEndDay.month.toString().padLeft(2, '0')}.${actualEndDay.day.toString().padLeft(2, '0')}';
  final days = getTripDays(startDay, actualEndDay);

  if (startDay == actualEndDay) {
    return '$startStr ($days일) 선택하기'; // 당일 여행이면 ~ 없이 단일 날짜만 출력
  } else {
    return '$startStr ~ $endStr ($days일) 선택하기';
  }
}

/// 게시글 작성 유효성 검사
class PostValidator {
  static const int minTitleLength = 1; // 제목은 한 글자 이상
  static const int minContentLength = 5; // 본문은 5자 이상

  static String? validateTitle(String text) {
    if (text.trim().isEmpty) {
      return '제목을 입력해주세요';
    }
    return null;
  }

  static String? validateContent(String text) {
    if (text.trim().isEmpty) {
      return '내용을 입력해주세요';
    }
    if (text.trim().length < minContentLength) {
      return '5자 이상 입력해주세요';
    }
    return null;
  }
}

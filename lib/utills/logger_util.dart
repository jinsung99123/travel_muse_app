import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kReleaseMode ? Level.off : Level.debug,
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 3,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    // ignore: deprecated_member_use
    printTime: false,
  ),
);

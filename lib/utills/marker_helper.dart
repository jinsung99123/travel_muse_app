import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';      
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// SVG 에셋 파일을 기반으로 Google Maps의 마커 아이콘(BitmapDescriptor)을 생성합니다.
Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
  String assetPath, {
  ui.Size size = const ui.Size(48, 48),
}) async {
  // SVG → PictureInfo
  final pictureInfo = await vg.loadPicture(
    SvgAssetLoader(assetPath),
    null,
  );
  
  final dpr = ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
  final targetW = (size.width * dpr).toInt();
  final targetH = (size.height * dpr).toInt();

  final scale = math.min(
    targetW / pictureInfo.size.width,
    targetH / pictureInfo.size.height,
  );

  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder)
    ..scale(scale)
    ..drawPicture(pictureInfo.picture);
  final img = await recorder.endRecording().toImage(targetW, targetH);

  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

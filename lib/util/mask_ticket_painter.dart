import 'package:flutter/material.dart';
import 'dart:math';

import 'package:follow_of_price/theme/colors.dart';

///Class represents mask with circles(holes) and and two cutouts (as hemispheres).
///[lineWidth] - radius of circles(holes).
///[marginBetweenCircles] - margin between circles(holes).
///[colorBg] - background color of ticket.
///[colorShadow] - shadow color of ticket.
///[shadowSize] - size or offset of shadow ticket.
///[_radiusArc] - radius of two cutouts (as hemispheres).
class MaskTicketPainter extends CustomPainter {
  final double lineWidth;
  final double lineHeight;
  final double marginBetweenCircles;
  final Color colorBg;
  final Color colorShadow;
  final double shadowSize;
  late double _radiusArc;

  MaskTicketPainter({
    required this.lineWidth,
    required this.lineHeight,
    required this.marginBetweenCircles,
    required this.colorBg,
    required this.colorShadow,
    required this.shadowSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _radiusArc = size.height / 2;

    final pathPolygon = Path()
      ..addRRect(RRect.fromLTRBR(
          0.0, 0.0, size.width, size.height, const Radius.circular(0)))
      ..close();

    final pathMask = Path();
    pathMask.addArc(
      Rect.fromLTWH(-_radiusArc, 0, size.height, _radiusArc * 2),
      degToRad(90).toDouble(),
      degToRad(-180).toDouble(),
    );
    pathMask.addArc(
      Rect.fromLTWH(size.width - _radiusArc, 0, _radiusArc * 2, _radiusArc * 2),
      degToRad(90).toDouble(),
      degToRad(180).toDouble(),
    );

    Path lines = Path();

    double tempWidth = size.width - (size.height);
    int count = tempWidth ~/ lineWidth;
    count = count - 10;
    double spaceWidth = (tempWidth - (count * lineWidth)) / (count + 1);
    double startLeft = _radiusArc;

    for (int i = 0; i < count; i++) {
      startLeft += spaceWidth;
      lines.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(startLeft, (size.height / 2) - (lineHeight / 2),
              lineWidth, lineHeight),
          const Radius.circular(6),
        ),
      );
      startLeft += lineWidth;
    }

    pathMask.addPath(lines, Offset.zero);
    pathMask.close();

    final pathCombined = Path.combine(
      PathOperation.difference,
      pathPolygon,
      pathMask,
    );

    final paint = Paint()
      ..color = colorBg
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;

    canvas.drawShadow(pathCombined, colorShadow, shadowSize, false);
    canvas.drawPath(
      pathCombined,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  /// Method to convert degree to radians
  num degToRad(num deg) => deg * (pi / 180.0);
}

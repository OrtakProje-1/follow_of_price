import 'dart:math';

import 'package:flutter/material.dart';

class MaskTicketPainter extends CustomPainter {
  final double radiusCircle;
  final double marginBetweenCircles;
  final Color colorBg;
  final Color colorShadow;
  final double shadowSize;
  late double _radiusArc;

  MaskTicketPainter({
    required this.radiusCircle,
    required this.marginBetweenCircles,
    required this.colorBg,
    required this.colorShadow,
    required this.shadowSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _radiusArc = size.width / 2;

    final pathPolygon = Path()
      ..addRRect(RRect.fromLTRBR(
          0.0, 0.0, size.width, size.height, Radius.circular(0)))
      ..close();

    final pathMask = Path()
      ..addArc(Rect.fromLTWH(0, -_radiusArc, _radiusArc * 2, _radiusArc * 2), 0,
          degToRad(180).toDouble())
      ..addArc(
          Rect.fromLTWH(
              0, size.height - _radiusArc, _radiusArc * 2, _radiusArc * 2),
          degToRad(-180).toDouble(),
          degToRad(180).toDouble())
      ..addPath(
          _getCirclesPath(
              radiusCircle, _radiusArc, marginBetweenCircles, 0, size.height),
          Offset(0, 0))
      ..close();

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

  ///Calculate optimized radius of circles, based on the set radius [radiusCircle].
  double _getOptimizedRadiusCircle(
    double startTopY,
    endBottomY,
    double radiusCircle,
  ) {
    var indexCircle = 0;
    final diameterCircle = radiusCircle * 2;

    while (startTopY < endBottomY) {
      startTopY += diameterCircle;
      startTopY += marginBetweenCircles;

      indexCircle++;
    }

    //correction to bottom line of circle
    startTopY -= radiusCircle;

    final remainSpace = endBottomY - startTopY;
    final correctionBalance = remainSpace / indexCircle;

    return radiusCircle + (correctionBalance / 2);
  }

  ///A baked path with all the holes that fit the current height of the item.
  Path _getCirclesPath(double radiusCircle, double radiusArc,
      double marginBetweenCircles, double startX, double height) {
    final marginByY = radiusCircle + radiusArc + marginBetweenCircles;
    final limitBottomY = height - marginByY;
    var currentOvalPosY = radiusCircle + marginByY;
    final optimizedRadiusCircle = _getOptimizedRadiusCircle(
      currentOvalPosY,
      limitBottomY,
      radiusCircle,
    );
    var path = Path();

    // correction start point by optimized radius
    currentOvalPosY = optimizedRadiusCircle + marginByY;

    while (currentOvalPosY <= limitBottomY) {
      currentOvalPosY += marginBetweenCircles / 2;

      path.addOval(Rect.fromCircle(
          center: Offset(startX + radiusArc, currentOvalPosY),
          radius: optimizedRadiusCircle));

      currentOvalPosY += (marginBetweenCircles / 2) + optimizedRadiusCircle * 2;
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  /// Method to convert degree to radians
  num degToRad(num deg) => deg * (pi / 180.0);
}
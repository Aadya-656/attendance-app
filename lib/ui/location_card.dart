// lib/attendance/location_card.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'attendance_model.dart';
import 'clock_controller.dart';

class LocationRadiusCard extends StatelessWidget {
  final ClockController ctrl;
  const LocationRadiusCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = ctrl.locationStatus.value == LocationStatus.loading;
      final within = ctrl.locationStatus.value == LocationStatus.withinRadius;
      final fraction = ctrl.distanceFraction.value.clamp(0.0, 1.5);

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 17, color: Color(0xFF888888)),
                const SizedBox(width: 6),
                const Text('Location Radius',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF888888))),
                const Spacer(),
                if (!isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: within
                            ? const Color(0xFFEFF6FF)
                            : const Color(0xFFFFF3F3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                        within ? 'Within range' : 'Out of range',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: within
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFDC2626))),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Color(0xFF2563EB))))
            else
              RadiusIndicator(
                  distanceFraction: fraction,
                  pulseAnimation: ctrl.pulseAnim,
                  within: within),
            const SizedBox(height: 12),
            if (!isLoading)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        within
                            ? '${(fraction * 100).toInt()}m from office (100m radius)'
                            : '${(fraction * 100).toInt()}m from office — outside 100m radius',
                        style: TextStyle(
                            fontSize: 12,
                            color: within
                                ? const Color(0xFF888888)
                                : const Color(0xFFDC2626),
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.explore_outlined,
                          size: 13, color: Color(0xFF888888)),
                      const SizedBox(width: 4),
                      Text(
                        'Lat: ${ctrl.currentLatitude.value.toStringAsFixed(5)}  |  Lng: ${ctrl.currentLongitude.value.toStringAsFixed(5)}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                            fontFeatures: [FontFeature.tabularFigures()]),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }
}

class RadiusIndicator extends StatelessWidget {
  final double distanceFraction;
  final Animation<double> pulseAnimation;
  final bool within;

  const RadiusIndicator({
    super.key,
    required this.distanceFraction,
    required this.pulseAnimation,
    required this.within,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: RadiusPainter(
              distanceFraction: distanceFraction,
              pulseValue: pulseAnimation.value,
              within: within,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class RadiusPainter extends CustomPainter {
  final double distanceFraction;
  final double pulseValue;
  final bool within;

  RadiusPainter({
    required this.distanceFraction,
    required this.pulseValue,
    required this.within,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2 - 12;

    final activeColor =
    within ? const Color(0xFF60A5FA) : const Color(0xFFEF4444);
    final activeFill =
    within ? const Color(0xFF60A5FA) : const Color(0xFFEF4444);

    final pulseExpand = maxRadius * 0.55 + (pulseValue * 10);
    final pulsePaint = Paint()
      ..color = activeColor.withOpacity((1.0 - pulseValue) * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, pulseExpand, pulsePaint);

    final ringPaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, maxRadius, ringPaint);

    final safeZonePaint = Paint()
      ..color = activeFill.withOpacity(0.13)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius * 0.55, safeZonePaint);

    final safeZoneBorderPaint = Paint()
      ..color = activeColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, maxRadius * 0.55, safeZoneBorderPaint);

    final crossPaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(center.dx - maxRadius, center.dy),
        Offset(center.dx + maxRadius, center.dy), crossPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius),
        Offset(center.dx, center.dy + maxRadius), crossPaint);

    final displayFraction = math.min(distanceFraction, 1.18);
    final dotDistance = maxRadius * displayFraction;
    const angle = -math.pi / 4;
    final dotPos = Offset(
      center.dx + dotDistance * math.cos(angle),
      center.dy + dotDistance * math.sin(angle),
    );

    final glowPaint = Paint()
      ..color = activeColor.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(dotPos, 9, glowPaint);

    final dotPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(dotPos, 6, dotPaint);

    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(dotPos, 6, dotBorderPaint);

    final centerGlowPaint = Paint()
      ..color = const Color(0xFF2563EB).withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(center, 10, centerGlowPaint);

    final centerPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, centerPaint);

    final centerBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 6, centerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant RadiusPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.distanceFraction != distanceFraction ||
        oldDelegate.within != within;
  }
}
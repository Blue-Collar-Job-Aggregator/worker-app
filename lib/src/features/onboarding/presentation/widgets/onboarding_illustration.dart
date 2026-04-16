import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

/// Custom-painted illustrations for onboarding screens.
/// Flat design, real-world worker scenes, friendly and relatable.
///
/// Illustration style guide:
///  - Flat shapes, no 3D or gradients on people
///  - Rounded corners on all geometric elements
///  - Primary blue for emphasis, accent orange for call-to-action elements
///  - Skin tones use warm neutrals
///  - Background circles/shapes use primarySurface or accentSurface
///  - Minimal detail — convey the concept, not realism
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.type,
    this.size = 280,
  });

  final IllustrationType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: switch (type) {
          IllustrationType.findWorkers => _FindWorkersPainter(),
          IllustrationType.manageTeams => _ManageTeamsPainter(),
          IllustrationType.workAndEarn => _WorkAndEarnPainter(),
        },
      ),
    );
  }
}

enum IllustrationType { findWorkers, manageTeams, workAndEarn }

// ─── Shared helpers ───────────────────────────────────────────────

const _skinTone = Color(0xFFD4A574);
const _skinToneDark = Color(0xFFB8865C);
const _hair = Color(0xFF2C2C2C);
const _helmet = Color(0xFFF59E0B);
const _shirt1 = Color(0xFF2563EB);
const _shirt2 = Color(0xFF16A34A);
const _shirt3 = Color(0xFFF59E0B);
const _pants = Color(0xFF475569);

void _drawPerson(
  Canvas canvas,
  Offset center,
  double scale, {
  Color shirtColor = _shirt1,
  bool hasHelmet = false,
  bool isWaving = false,
}) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Head
  paint.color = _skinTone;
  canvas.drawCircle(
    center + Offset(0, -28 * scale),
    10 * scale,
    paint,
  );

  // Hair
  paint.color = _hair;
  canvas.drawArc(
    Rect.fromCircle(center: center + Offset(0, -28 * scale), radius: 10 * scale),
    pi,
    pi,
    true,
    paint,
  );

  // Helmet
  if (hasHelmet) {
    paint.color = _helmet;
    canvas.drawArc(
      Rect.fromCircle(center: center + Offset(0, -30 * scale), radius: 12 * scale),
      pi,
      pi,
      true,
      paint,
    );
    // Brim
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center + Offset(0, -28 * scale), width: 28 * scale, height: 4 * scale),
        Radius.circular(2 * scale),
      ),
      paint,
    );
  }

  // Body
  paint.color = shirtColor;
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(center: center + Offset(0, -8 * scale), width: 20 * scale, height: 28 * scale),
      Radius.circular(4 * scale),
    ),
    paint,
  );

  // Arms
  paint.color = _skinToneDark;
  if (isWaving) {
    // Right arm waving
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center + Offset(14 * scale, -22 * scale), width: 6 * scale, height: 18 * scale),
        Radius.circular(3 * scale),
      ),
      paint,
    );
  } else {
    // Right arm down
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center + Offset(14 * scale, -4 * scale), width: 6 * scale, height: 22 * scale),
        Radius.circular(3 * scale),
      ),
      paint,
    );
  }
  // Left arm
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(center: center + Offset(-14 * scale, -4 * scale), width: 6 * scale, height: 22 * scale),
      Radius.circular(3 * scale),
    ),
    paint,
  );

  // Legs
  paint.color = _pants;
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(center: center + Offset(-5 * scale, 18 * scale), width: 8 * scale, height: 24 * scale),
      Radius.circular(3 * scale),
    ),
    paint,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(center: center + Offset(5 * scale, 18 * scale), width: 8 * scale, height: 24 * scale),
      Radius.circular(3 * scale),
    ),
    paint,
  );
}

void _drawBackgroundCircle(Canvas canvas, Offset center, double radius, Color color) {
  canvas.drawCircle(center, radius, Paint()..color = color);
}

// ─── Screen 1: Find Workers ──────────────────────────────────────

class _FindWorkersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background circle
    _drawBackgroundCircle(canvas, Offset(cx, cy), size.width * 0.4, AppColors.primarySurface);

    // Secondary decorative circles
    _drawBackgroundCircle(canvas, Offset(cx - 90, cy - 60), 20, AppColors.accentSurface);
    _drawBackgroundCircle(canvas, Offset(cx + 95, cy + 50), 14, AppColors.primarySurface);

    // Search/magnifying glass icon
    final searchPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(cx, cy - 50), 24, searchPaint);
    canvas.drawLine(
      Offset(cx + 17, cy - 33),
      Offset(cx + 30, cy - 20),
      searchPaint,
    );

    // Workers in a row
    _drawPerson(canvas, Offset(cx - 60, cy + 50), 0.85, shirtColor: _shirt1, hasHelmet: true);
    _drawPerson(canvas, Offset(cx, cy + 45), 0.9, shirtColor: _shirt2, isWaving: true);
    _drawPerson(canvas, Offset(cx + 60, cy + 50), 0.85, shirtColor: _shirt3, hasHelmet: true);

    // Small sparkle dots
    final dotPaint = Paint()..color = AppColors.accent;
    canvas.drawCircle(Offset(cx - 40, cy - 70), 4, dotPaint);
    canvas.drawCircle(Offset(cx + 50, cy - 65), 3, dotPaint);
    canvas.drawCircle(Offset(cx + 80, cy - 30), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Screen 2: Manage Teams ─────────────────────────────────────

class _ManageTeamsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background
    _drawBackgroundCircle(canvas, Offset(cx, cy + 10), size.width * 0.4, AppColors.accentSurface);
    _drawBackgroundCircle(canvas, Offset(cx + 80, cy - 70), 16, AppColors.primarySurface);

    // Clipboard/board
    final boardPaint = Paint()..color = AppColors.surface;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy - 40), width: 70, height: 90),
        const Radius.circular(8),
      ),
      boardPaint,
    );
    // Clipboard border
    final borderPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy - 40), width: 70, height: 90),
        const Radius.circular(8),
      ),
      borderPaint,
    );
    // Clipboard top clip
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy - 86), width: 30, height: 10),
        const Radius.circular(4),
      ),
      Paint()..color = AppColors.primary,
    );
    // Check lines on clipboard
    final checkPaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 3; i++) {
      final y = cy - 65 + (i * 22.0);
      // Check mark
      canvas.drawPath(
        Path()
          ..moveTo(cx - 22, y)
          ..lineTo(cx - 16, y + 6)
          ..lineTo(cx - 8, y - 4),
        checkPaint,
      );
      // Line
      canvas.drawLine(
        Offset(cx - 2, y),
        Offset(cx + 24, y),
        Paint()
          ..color = AppColors.border
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Contractor (center, larger)
    _drawPerson(canvas, Offset(cx, cy + 55), 0.9, shirtColor: AppColors.primary, hasHelmet: false);

    // Workers (smaller, on sides)
    _drawPerson(canvas, Offset(cx - 70, cy + 65), 0.7, shirtColor: _shirt3, hasHelmet: true);
    _drawPerson(canvas, Offset(cx + 70, cy + 65), 0.7, shirtColor: _shirt2, hasHelmet: true);

    // Connection lines from contractor to workers
    final linePaint = Paint()
      ..color = AppColors.primaryLight
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    // Dashed effect via short segments
    canvas.drawLine(Offset(cx - 14, cy + 38), Offset(cx - 56, cy + 48), linePaint);
    canvas.drawLine(Offset(cx + 14, cy + 38), Offset(cx + 56, cy + 48), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Screen 3: Work & Earn ──────────────────────────────────────

class _WorkAndEarnPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background
    _drawBackgroundCircle(canvas, Offset(cx, cy), size.width * 0.4, AppColors.successSurface);
    _drawBackgroundCircle(canvas, Offset(cx - 85, cy + 40), 12, AppColors.accentSurface);

    // Upward trending graph
    final graphPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final graphPath = Path()
      ..moveTo(cx - 60, cy - 10)
      ..quadraticBezierTo(cx - 30, cy - 15, cx - 10, cy - 30)
      ..quadraticBezierTo(cx + 10, cy - 45, cx + 30, cy - 50)
      ..quadraticBezierTo(cx + 45, cy - 55, cx + 60, cy - 65);

    canvas.drawPath(graphPath, graphPaint);

    // Arrow at end of graph
    canvas.drawLine(
      Offset(cx + 60, cy - 65),
      Offset(cx + 52, cy - 58),
      graphPaint,
    );
    canvas.drawLine(
      Offset(cx + 60, cy - 65),
      Offset(cx + 50, cy - 67),
      graphPaint,
    );

    // Coins/money symbols
    final coinPaint = Paint()..color = AppColors.accent;
    final coinBorder = Paint()
      ..color = AppColors.accentDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Coin 1
    canvas.drawCircle(Offset(cx + 70, cy - 35), 14, coinPaint);
    canvas.drawCircle(Offset(cx + 70, cy - 35), 14, coinBorder);
    // ₹ symbol
    final rupeePaint = Paint()
      ..color = AppColors.accentDark
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx + 65, cy - 40), Offset(cx + 75, cy - 40), rupeePaint);
    canvas.drawLine(Offset(cx + 65, cy - 37), Offset(cx + 75, cy - 37), rupeePaint);
    canvas.drawLine(Offset(cx + 68, cy - 40), Offset(cx + 73, cy - 28), rupeePaint);

    // Coin 2 (smaller, behind)
    canvas.drawCircle(Offset(cx + 55, cy - 25), 10, Paint()..color = AppColors.accentLight);
    canvas.drawCircle(Offset(cx + 55, cy - 25), 10, coinBorder);

    // Worker with thumbs up
    _drawPerson(canvas, Offset(cx - 20, cy + 50), 0.95, shirtColor: _shirt1, hasHelmet: true, isWaving: true);

    // Second person
    _drawPerson(canvas, Offset(cx + 50, cy + 55), 0.8, shirtColor: _shirt2, hasHelmet: false);

    // Stars / sparkles
    final starPaint = Paint()..color = AppColors.accent;
    _drawStar(canvas, Offset(cx - 70, cy - 55), 8, starPaint);
    _drawStar(canvas, Offset(cx + 85, cy - 10), 6, starPaint);
    _drawStar(canvas, Offset(cx - 50, cy - 30), 5, Paint()..color = AppColors.primaryLight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
  final path = Path();
  for (var i = 0; i < 4; i++) {
    final angle = (i * pi / 2) - pi / 2;
    final outerX = center.dx + radius * cos(angle);
    final outerY = center.dy + radius * sin(angle);
    if (i == 0) {
      path.moveTo(outerX, outerY);
    } else {
      path.lineTo(outerX, outerY);
    }
    final innerAngle = angle + pi / 4;
    final innerX = center.dx + (radius * 0.4) * cos(innerAngle);
    final innerY = center.dy + (radius * 0.4) * sin(innerAngle);
    path.lineTo(innerX, innerY);
  }
  path.close();
  canvas.drawPath(path, paint);
}

import 'package:flutter/material.dart';

class NeonOutlineIcon extends StatelessWidget {
  const NeonOutlineIcon({super.key, required this.painter, this.size = 28});

  final CustomPainter painter;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: painter),
    );
  }
}

Paint _stroke(Color c, double w) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..color = c;

Paint _glow(Color c, double w, double blurSigma) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = w * 1.5 // Multiplier reduced from 2.0
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..color =
      c.withValues(alpha: 0.60) // Higher opacity to compensate for thinness
  ..maskFilter = MaskFilter.blur(
    BlurStyle.normal,
    blurSigma * 0.4,
  ); // Very tight blur

/// A) Subaru badge: Accurate Pleiades cluster (1 big star, 5 small stars)
class SubaruBadgePainter extends CustomPainter {
  SubaruBadgePainter({required this.color, this.glow = true});

  final Color color;
  final bool glow;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.shortestSide;
    final sw = w * 0.03; // Ultra-thin stroke

    // Oval frame
    final oval = Rect.fromLTWH(w * 0.10, w * 0.28, w * 0.80, w * 0.44);

    // Star coordinates
    final bigStar = Offset(w * 0.38, w * 0.46);
    final bigR = w * 0.08; // Slightly larger for star shape impact

    // 5 Small stars
    final smallStars = <Offset>[
      Offset(w * 0.58, w * 0.42),
      Offset(w * 0.68, w * 0.40),
      Offset(w * 0.74, w * 0.48),
      Offset(w * 0.64, w * 0.52),
      Offset(w * 0.54, w * 0.60),
    ];
    final smallR = w * 0.035;

    // Helper to build a 4-pointed star path
    Path starPath(Offset center, double r) {
      final inner = r * 0.4; // Inner radius ratio
      return Path()
        ..moveTo(center.dx, center.dy - r) // Top
        ..lineTo(center.dx + inner, center.dy - inner)
        ..lineTo(center.dx + r, center.dy) // Right
        ..lineTo(center.dx + inner, center.dy + inner)
        ..lineTo(center.dx, center.dy + r) // Bottom
        ..lineTo(center.dx - inner, center.dy + inner)
        ..lineTo(center.dx - r, center.dy) // Left
        ..lineTo(center.dx - inner, center.dy - inner)
        ..close();
    }

    void draw(Paint p) {
      canvas.drawOval(oval, p);

      // Draw big star
      canvas.drawPath(starPath(bigStar, bigR), p);

      // Draw small stars
      for (final d in smallStars) {
        canvas.drawPath(starPath(d, smallR), p);
      }
    }

    if (glow) draw(_glow(color, sw, w * 0.04));
    draw(_stroke(color, sw));
  }

  @override
  bool shouldRepaint(covariant SubaruBadgePainter old) =>
      old.color != color || old.glow != glow;
}

/// B) Boxer engine: Classic Flat-4 Silhouette
class BoxerEnginePainter extends CustomPainter {
  BoxerEnginePainter({
    required this.color,
    this.pistonColor = const Color.fromARGB(
      50,
      200,
      192,
      192,
    ), // Pure white/chrome
    this.glow = false,
  });

  final Color color;
  final Color pistonColor;
  final bool glow;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.shortestSide;
    final sw = w * 0.03;

    // Central block (crankcase) - tall rectangle in center
    final block = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, w * 0.5),
        width: w * 0.20,
        height: w * 0.58,
      ),
      Radius.circular(w * 0.03),
    );

    // Left cylinders (horizontal rectangles) - spread apart vertically
    final leftCyl1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, w * 0.25, w * 0.22, w * 0.10),
      Radius.circular(w * 0.02),
    );
    final leftCyl2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, w * 0.65, w * 0.22, w * 0.10),
      Radius.circular(w * 0.02),
    );

    // Right cylinders (horizontal rectangles) - spread apart vertically
    final rightCyl1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.60, w * 0.25, w * 0.22, w * 0.10),
      Radius.circular(w * 0.02),
    );
    final rightCyl2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.60, w * 0.65, w * 0.22, w * 0.10),
      Radius.circular(w * 0.02),
    );

    // Pistons (side-view: vertical rounded rectangles with dome crown)
    final pistonW = w * 0.15; // Width - even bigger
    final pistonH = w * 0.26; // Height - even bigger
    final pistonRadius = Radius.circular(w * 0.03);
    final wristPinR = w * 0.02; // Wrist pin bore radius

    // Piston centers - spread apart vertically
    final lp1Center = Offset(w * 0.07, w * 0.30);
    final lp2Center = Offset(w * 0.07, w * 0.70);
    final rp1Center = Offset(w * 0.93, w * 0.30);
    final rp2Center = Offset(w * 0.93, w * 0.70);

    // Piston body rectangles
    final leftPiston1 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: lp1Center, width: pistonW, height: pistonH),
      pistonRadius,
    );
    final leftPiston2 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: lp2Center, width: pistonW, height: pistonH),
      pistonRadius,
    );
    final rightPiston1 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: rp1Center, width: pistonW, height: pistonH),
      pistonRadius,
    );
    final rightPiston2 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: rp2Center, width: pistonW, height: pistonH),
      pistonRadius,
    );

    // Draw structure (block + cylinders) in main color
    void drawStructure(Paint p) {
      canvas.drawRRect(block, p);
      canvas.drawRRect(leftCyl1, p);
      canvas.drawRRect(leftCyl2, p);
      canvas.drawRRect(rightCyl1, p);
      canvas.drawRRect(rightCyl2, p);
    }

    // Thinner stroke for piston details
    final pistonSw = sw * 0.4; // Extra thin for piston details

    // Draw pistons (side-view with crown, rings, wrist pin, connecting rods)
    void drawPistons(Paint p) {
      // Use thinner stroke for piston details
      final thinP = Paint()
        ..style = p.style
        ..strokeWidth = pistonSw
        ..strokeCap = p.strokeCap
        ..strokeJoin = p.strokeJoin
        ..color = p.color
        ..maskFilter = p.maskFilter;

      // Piston bodies
      canvas.drawRRect(leftPiston1, thinP);
      canvas.drawRRect(leftPiston2, thinP);
      canvas.drawRRect(rightPiston1, thinP);
      canvas.drawRRect(rightPiston2, thinP);

      // Connecting rods (from piston center toward cylinder)
      // Left rods going right toward cylinders
      canvas.drawLine(lp1Center, Offset(w * 0.18, w * 0.30), thinP);
      canvas.drawLine(lp2Center, Offset(w * 0.18, w * 0.70), thinP);
      // Right rods going left toward cylinders
      canvas.drawLine(rp1Center, Offset(w * 0.82, w * 0.30), thinP);
      canvas.drawLine(rp2Center, Offset(w * 0.82, w * 0.70), thinP);

      // Wrist pin bores (circles in center of each piston)
      canvas.drawCircle(lp1Center, wristPinR, thinP);
      canvas.drawCircle(lp2Center, wristPinR, thinP);
      canvas.drawCircle(rp1Center, wristPinR, thinP);
      canvas.drawCircle(rp2Center, wristPinR, thinP);

      // Piston ring grooves (3 rings per piston - compression + oil)
      // Left piston 1 (centered at 0.30)
      canvas.drawLine(
        Offset(w * 0.02, w * 0.21),
        Offset(w * 0.12, w * 0.21),
        thinP,
      );
      canvas.drawLine(
        Offset(w * 0.02, w * 0.25),
        Offset(w * 0.12, w * 0.25),
        thinP,
      );
      canvas.drawLine(
        Offset(w * 0.02, w * 0.39),
        Offset(w * 0.12, w * 0.39),
        thinP,
      );
      // Left piston 2 (centered at 0.70)
      canvas.drawLine(
        Offset(w * 0.02, w * 0.61),
        Offset(w * 0.12, w * 0.61),
        thinP,
      );
      canvas.drawLine(
        Offset(w * 0.02, w * 0.75),
        Offset(w * 0.12, w * 0.75),
        thinP,
      );
      canvas.drawLine(
        Offset(w * 0.02, w * 0.79),
        Offset(w * 0.12, w * 0.79),
        thinP,
      );
      // Right piston 1 (centered at 0.30)
      canvas.drawLine(
        Offset(w * 0.88, w * 0.21),
        Offset(w * 0.98, w * 0.21),
        thinP,
      );
      canvas.drawLine(
        Offset(w * 0.88, w * 0.25),
        Offset(w * 0.98, w * 0.25),
        thinP,
      );
      canvas.drawLine(
        Offset(w * 0.88, w * 0.39),
        Offset(w * 0.98, w * 0.39),
        thinP,
      );
      // Right piston 2 (centered at 0.70)
      canvas.drawLine(
        Offset(w * 0.88, w * 0.61),
        Offset(w * 0.98, w * 0.61),
        thinP,
      );
      canvas.drawLine(
        Offset(w * 0.88, w * 0.75),
        Offset(w * 0.98, w * 0.75),
        thinP,
      );
      canvas.drawLine(
        Offset(w * 0.88, w * 0.79),
        Offset(w * 0.98, w * 0.79),
        thinP,
      );
    }

    // Glow layers
    if (glow) {
      drawStructure(_glow(color, sw, w * 0.015));
      drawPistons(_glow(pistonColor, pistonSw, w * 0.015));
    }
    // Solid stroke layers
    drawStructure(_stroke(color, sw));
    drawPistons(_stroke(pistonColor, pistonSw));
  }

  @override
  bool shouldRepaint(covariant BoxerEnginePainter old) =>
      old.color != color || old.pistonColor != pistonColor || old.glow != glow;
}

/// C) Category grid
class CategoryGridPainter extends CustomPainter {
  CategoryGridPainter({required this.color, this.glow = true});

  final Color color;
  final bool glow;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.shortestSide;
    final sw = w * 0.03; // Ultra-thin stroke
    final r = Radius.circular(w * 0.06);

    Rect cell(double x, double y) =>
        Rect.fromLTWH(w * x, w * y, w * 0.28, w * 0.28);

    final cells = [
      RRect.fromRectAndRadius(cell(0.14, 0.18), r),
      RRect.fromRectAndRadius(cell(0.58, 0.18), r),
      RRect.fromRectAndRadius(cell(0.14, 0.56), r),
      RRect.fromRectAndRadius(cell(0.58, 0.56), r),
    ];

    void draw(Paint p) {
      for (final c in cells) {
        canvas.drawRRect(c, p);
      }
      // tiny “spec lines” in bottom-right cell
      canvas.drawLine(
        Offset(w * 0.62, w * 0.66),
        Offset(w * 0.82, w * 0.66),
        p,
      );
      canvas.drawLine(
        Offset(w * 0.62, w * 0.74),
        Offset(w * 0.78, w * 0.74),
        p,
      );
    }

    if (glow) draw(_glow(color, sw, w * 0.04));
    draw(_stroke(color, sw));
  }

  @override
  bool shouldRepaint(covariant CategoryGridPainter old) =>
      old.color != color || old.glow != glow;
}

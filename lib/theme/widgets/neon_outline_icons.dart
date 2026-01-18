import 'package:flutter/material.dart';

class NeonOutlineIcon extends StatelessWidget {
  const NeonOutlineIcon({
    super.key,
    required this.painter,
    this.size = 28,
  });

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
  ..color = c.withValues(alpha: 0.60) // Higher opacity to compensate for thinness
  ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma * 0.4); // Very tight blur

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
      Offset(w * 0.54, w * 0.60)
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
  BoxerEnginePainter({required this.color, this.glow = true});

  final Color color;
  final bool glow;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.shortestSide;
    final sw = w * 0.03;

    // Central block (crankcase) - tall rectangle in center
    final block = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, w * 0.5), width: w * 0.20, height: w * 0.50),
      Radius.circular(w * 0.03),
    );

    // Left cylinders (horizontal rectangles)
    final leftCyl1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, w * 0.32, w * 0.30, w * 0.10),
      Radius.circular(w * 0.02),
    );
    final leftCyl2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, w * 0.58, w * 0.30, w * 0.10),
      Radius.circular(w * 0.02),
    );

    // Right cylinders (horizontal rectangles)
    final rightCyl1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.60, w * 0.32, w * 0.30, w * 0.10),
      Radius.circular(w * 0.02),
    );
    final rightCyl2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.60, w * 0.58, w * 0.30, w * 0.10),
      Radius.circular(w * 0.02),
    );

    // Pistons (larger circles at the ends of each cylinder with inner detail)
    final pistonR = w * 0.09; // Larger pistons
    final pistonInnerR = w * 0.04; // Inner detail
    final leftPiston1 = Offset(w * 0.10, w * 0.37);
    final leftPiston2 = Offset(w * 0.10, w * 0.63);
    final rightPiston1 = Offset(w * 0.90, w * 0.37);
    final rightPiston2 = Offset(w * 0.90, w * 0.63);

    void draw(Paint p) {
      // Draw central block
      canvas.drawRRect(block, p);

      // Draw cylinders
      canvas.drawRRect(leftCyl1, p);
      canvas.drawRRect(leftCyl2, p);
      canvas.drawRRect(rightCyl1, p);
      canvas.drawRRect(rightCyl2, p);

      // Draw pistons (outer circle)
      canvas.drawCircle(leftPiston1, pistonR, p);
      canvas.drawCircle(leftPiston2, pistonR, p);
      canvas.drawCircle(rightPiston1, pistonR, p);
      canvas.drawCircle(rightPiston2, pistonR, p);
      
      // Draw piston inner detail (valve/spark plug representation)
      canvas.drawCircle(leftPiston1, pistonInnerR, p);
      canvas.drawCircle(leftPiston2, pistonInnerR, p);
      canvas.drawCircle(rightPiston1, pistonInnerR, p);
      canvas.drawCircle(rightPiston2, pistonInnerR, p);
    }

    if (glow) draw(_glow(color, sw, w * 0.015)); // Tight glow for clarity
    draw(_stroke(color, sw));
  }

  @override
  bool shouldRepaint(covariant BoxerEnginePainter old) =>
      old.color != color || old.glow != glow;
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
      canvas.drawLine(Offset(w * 0.62, w * 0.66), Offset(w * 0.82, w * 0.66), p);
      canvas.drawLine(Offset(w * 0.62, w * 0.74), Offset(w * 0.78, w * 0.74), p);
    }

    if (glow) draw(_glow(color, sw, w * 0.04));
    draw(_stroke(color, sw));
  }

  @override
  bool shouldRepaint(covariant CategoryGridPainter old) =>
      old.color != color || old.glow != glow;
}

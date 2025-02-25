part of 'anchored_overlay.dart';

/// Background and cutout painter
class _CutoutPainter extends CustomPainter {
  /// Background and cutout painter
  const _CutoutPainter({
    required this.cutouts,
    this.backgroundColor,
    this.borderRadius = 10,
    this.padding = EdgeInsets.zero,
  });

  /// List of cutouts of widgets upon which overlays are inserted
  final List<Rect> cutouts;

  /// Background color
  final Color? backgroundColor;

  /// Border radius of cutouts
  final double borderRadius;

  /// Padding between widget and its cutout
  final EdgeInsets padding;

  @override
  void paint(Canvas canvas, Size size) {
    // Background style
    final backgroundPaint = Paint()
      ..color = backgroundColor ?? Colors.black.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    // Background path
    final backgroundPath = Path()..addRect(Offset.zero & size);

    // Cutouts path
    final cutoutPath = Path();
    for (final c in cutouts) {
      final cutout = Rect.fromCenter(
        center: Offset(c.center.dx + (padding.left - padding.right) / 2,
            c.center.dy + (padding.top - padding.bottom) / 2),
        width: c.width + padding.left + padding.right,
        height: c.height + padding.top + padding.bottom,
      );
      cutoutPath.addRRect(
        RRect.fromRectAndRadius(
          cutout,
          Radius.circular(borderRadius),
        ),
      );
    }

    // Combination of background and cutouts paths with difference applied
    final combinedPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    // ~* Drawing *~
    canvas.drawPath(combinedPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(_CutoutPainter oldDelegate) =>
      !listEquals(oldDelegate.cutouts, cutouts);
}

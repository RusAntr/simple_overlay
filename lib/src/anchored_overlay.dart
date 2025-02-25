import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'overlay_manager.dart';
part 'overlay_builder.dart';
part 'overlay_data.dart';
part 'cutout_painter.dart';
part 'consts.dart';

/// Overlay widget with background
class AnchoredOverlay extends StatelessWidget {
  /// Overlay widget with background
  const AnchoredOverlay({
    super.key,
    required this.parentKey,
    required this.showOverlay,
    required this.overlayBuilder,
    required this.child,
    this.onOverlayTap,
    this.onBackgroundTap,
    this.offset = Offset.zero,
  });

  /// Show overlay?
  final bool showOverlay;

  /// Builder of an overlay widget
  final Widget Function(BuildContext) overlayBuilder;

  /// Child upon which we overlay
  final Widget child;

  /// What happens when we tap on overlay
  final VoidCallback? onOverlayTap;

  /// What happens when we tap on background
  final VoidCallback? onBackgroundTap;

  /// Overlay offset [FractionalTranslation]
  final Offset offset;

  /// Key to correctly identify overlay. Best to use [ValueKey]
  final Key parentKey;

  @override
  Widget build(BuildContext context) {
    return _OverlayBuilder(
      parentKey: parentKey,
      showOverlay: showOverlay,
      onOverlayTap: onOverlayTap,
      onOverlayBackgroundTap: onBackgroundTap,
      overlayBuilder: (BuildContext overlayContext) {
        var anchorPoint = Offset.zero;
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          anchorPoint = box.localToGlobal(box.paintBounds.center);
        }

        return Positioned(
          top: anchorPoint.dy,
          left: anchorPoint.dx,
          child: FractionalTranslation(
            translation: offset,
            child: GestureDetector(
              onTap: () {
                onOverlayTap?.call();
                OverlayManager.instance.removeOverlay(parentKey);
              },
              child: overlayBuilder(overlayContext),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

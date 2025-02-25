part of 'anchored_overlay.dart';

/// Simple overlay data class
class OverlayData {
  /// Simple overlay data class
  const OverlayData({
    required this.key,
    required this.content,
    required this.cutout,
    required this.context,
    this.onTap,
  });

  /// Key to correctly identify overlay. Best to use [ValueKey]
  final Key key;

  /// Overlay content (what will be displayed)
  final Widget content;

  /// Rect of a widget upon which we insert overlay
  final Rect cutout;

  /// BuildContext of a widget upon which we insert overlay
  final BuildContext? context;

  /// What happens we we tap on the overlay
  final VoidCallback? onTap;

  /// Invalid [OverlayData] object
  static const invalid = OverlayData(
    key: ValueKey('invalid'),
    content: SizedBox.shrink(),
    cutout: Rect.zero,
    context: null,
  );
}

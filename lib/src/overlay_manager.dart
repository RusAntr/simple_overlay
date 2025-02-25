part of 'anchored_overlay.dart';

/// Overlay manager
///
/// Here we insert/remove overlays
class OverlayManager {
  factory OverlayManager() => instance;
  OverlayManager._internal();
  static final OverlayManager instance = OverlayManager._internal();

  /// Color of a background
  Color backgroundColor = Colors.black.withValues(alpha: 0.45);

  /// Border radius of a cutout
  double borderRadius = 20;

  /// Padding between cutout and its widget
  EdgeInsets padding = EdgeInsets.zero;

  /// List of overlays
  final List<OverlayData> _overlays = [];

  /// Current overlay
  OverlayEntry? _overlayEntry;

  /// Add overlay
  void addOverlay(OverlayData data) {
    // Avoiding duplicates
    if (_overlays.any((a) => a.key == data.key)) return;

    _overlays.add(data);
    if (data.context != null) _updateOverlay(data.context!);
  }

  /// Remove overlay
  void removeOverlay(Key key) {
    final toRemove = _overlays.singleWhere(
      (o) => o.key == key,
      orElse: () => OverlayData.invalid,
    );
    if (toRemove != OverlayData.invalid && toRemove.context != null) {
      _overlays.remove(toRemove);
      _updateOverlay(toRemove.context!);
    }
  }

  /// Update overlay
  void _updateOverlay(BuildContext parentContext) {
    _overlayEntry?.remove();

    // If list of overlays is empty we exist
    if (_overlays.isEmpty) {
      _overlayEntry = null;
      return;
    }

    // Main overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Background
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // When clicking on the background we call onTap method of
                  // the last overlay and then remove it
                  _overlays.last.onTap?.call();
                  removeOverlay(_overlays.last.key);
                },
                child: CustomPaint(
                  painter: _CutoutPainter(
                    cutouts: _overlays.map((o) => o.cutout).toList(),
                    backgroundColor: backgroundColor,
                    borderRadius: borderRadius,
                    padding: padding,
                  ),
                ),
              ),
            ),
            // Overlays
            ..._overlays.map((o) => o.content),
          ],
        );
      },
    );
    // Inserting overlays
    if (_overlayEntry != null) {
      Overlay.of(parentContext).insert(_overlayEntry!);
    }
  }
}

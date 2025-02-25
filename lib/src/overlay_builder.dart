part of 'anchored_overlay.dart';

/// Overlay builder. Something like a layer between [AnchoredOverlay] (configuration)
/// and [OverlayManager] (controller). Responsible for searching render box and a rect
/// of a widget upon which we overlay. Also provides controller with [OverlayData]
class _OverlayBuilder extends StatefulWidget {
  const _OverlayBuilder({
    required this.parentKey,
    required this.showOverlay,
    required this.overlayBuilder,
    required this.child,
    this.onOverlayTap,
    this.onOverlayBackgroundTap,
  });

  /// Showing overlay?
  final bool showOverlay;

  /// Overlay builder
  final Widget Function(BuildContext) overlayBuilder;

  /// Widget upon which we overlay
  final Widget child;

  /// What happens on overlay tap
  final VoidCallback? onOverlayTap;

  /// What happens on background tap
  final VoidCallback? onOverlayBackgroundTap;

  /// Key to correctly identify overlay
  final Key parentKey;

  @override
  State<_OverlayBuilder> createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  /// Redner box of a widget upon which we overlay
  RenderBox? _renderBox;

  /// Rect cutout of a render box
  Rect? _cutoutRect;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateOverlay());
    }
  }

  @override
  void didUpdateWidget(_OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateOverlay());
    }
  }

  @override
  void dispose() {
    OverlayManager.instance.removeOverlay(widget.parentKey);
    super.dispose();
  }

  /// Update cutout
  void _updateCutoutRect() {
    if (!mounted) return;
    _renderBox = context.findRenderObject() as RenderBox?;
    if (_renderBox == null) return;

    final offset = _renderBox!.localToGlobal(Offset.zero);
    _cutoutRect = offset & _renderBox!.size;
  }

  /// Update overlay
  Future<void> _updateOverlay() async {
    // Sometimes there might be an animation when transitioning to a new screen
    // but before animation ends, the widget is already built and its context is
    // available which might cause rendering of an overlay in a wrong position.
    //
    // That's why there's a delay to help fix that. There's probabaly a more
    // effective and secure way of fixing this
    // FIXME(rus): Find another way to handle inserting overlay when transitiong
    // between screens
    await Future<void>.delayed(kOverlayDelay);

    _updateCutoutRect();

    if (!widget.showOverlay || _cutoutRect == null) {
      OverlayManager.instance.removeOverlay(widget.parentKey);
      return;
    }
    if (mounted) {
      OverlayManager.instance.addOverlay(
        OverlayData(
          key: widget.parentKey,
          content: widget.overlayBuilder(context),
          cutout: _cutoutRect ?? Rect.zero,
          onTap: widget.onOverlayTap,
          context: context,
        ),
      );
    }
  }

  /// Widget upon which we overlay
  @override
  Widget build(BuildContext context) => widget.child;
}

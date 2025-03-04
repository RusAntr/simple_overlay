# simple_overlay

A simple solution for showing multiple overlays on a single background with cutouts

## 🎥 Preview
image

## 🧭 Usage

#### 1. Configure global overlay style
```dart
 OverlayManager.instance
      ..backgroundColor = Colors.black.withValues(alpha: 0.7)
      ..borderRadius = 10
      ..padding = EdgeInsets.all(5);
```
#### 2. Wrap you widget with `AnchoredOverlay`
```dart
AnchoredOverlay(
    offset: Offset(0, 4.75),
    parentKey: ValueKey('SecondOverlay'), // do not repeat
    showOverlay: showSecondOverlay,
    useCenter: true,
    onOverlayTap: () {...},
    overlayBuilder: (context) => Material(...),
    child: ...
),
```

## 📜 `AnchoredOverlay` widget properties 

| Property | Required | Description |
| ------------- |:-------------:|---------------- |
| offset | false | Offset of the overlay from widget overlayed upon
| parentKey | true | A `Key` object to properly identify overlay in a list of overlays, MUST be unique|
| showOverlay | true | Whether the overlay is currently displayed |
| useCenter | false | Whether to display the overlay in the center |
| onOverlayTap | false | OnTap callback |
| overlayBuilder | true | Overlay content to be displayed |
| onBackgroundTap | false | onTap callback |
| delay | false | Delay before overlay appearance |
| child | true | Widget to overlay upon |
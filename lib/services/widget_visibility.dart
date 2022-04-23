import 'package:visibility_detector/visibility_detector.dart';

class WidgetVisibility {
  final List<String> _currentlyVisibleWidgets = [];

  List<String> get currentlyVisibleWidgets => _currentlyVisibleWidgets;

  void onVisibilityChanged(VisibilityInfo info) {
    final key = info.key.toString();
    final isVisible = info.visibleFraction > 0;

    if (isVisible) {
      if (!_currentlyVisibleWidgets.contains(key)) {
        _currentlyVisibleWidgets.add(key);
      }
    } else {
      if (_currentlyVisibleWidgets.contains(key)) {
        _currentlyVisibleWidgets.remove(key);
      }
    }
  }
}

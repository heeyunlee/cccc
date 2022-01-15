import 'package:google_ml_kit/google_ml_kit.dart';

extension TextElementExtension on TextElement {
  Map<String, dynamic> get toMap {
    final text = this.text;
    final points = cornerPoints.map((e) => [e.dx, e.dy]).toList();
    final map = {
      'text': text,
      'points': points,
    };

    return map;
  }
}

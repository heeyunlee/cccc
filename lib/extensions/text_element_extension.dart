import 'package:google_ml_kit/google_ml_kit.dart';

extension TextElementExtension on TextElement {
  Map<String, dynamic> get toMap {
    final text = this.text;
    final points = cornerPoints.map((e) => [e.x, e.y]).toList();
    final map = {
      'text': text,
      'points': points,
    };

    return map;
  }
}

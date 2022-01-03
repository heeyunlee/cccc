import 'package:cccc/extensions/enum_extension.dart';

extension CapExtension on String {
  String get title {
    final split = this.split(' ');
    final iter = split.map((e) => e[0].toUpperCase() + e.substring(1));

    return iter.join(' ');
  }

  T toEnum<T>(List<T> values) {
    return values.firstWhere((e) => this == enumToString(e));
  }
}

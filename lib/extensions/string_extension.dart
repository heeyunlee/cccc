import 'package:cccc/extensions/enum_extension.dart';

extension CapExtension on String {
  String get title {
    final split = this.split(' ');
    final iter = split.map((e) => e[0].toUpperCase() + e.substring(1));

    return iter.join(' ');
  }

  T toEnum<T>(List<T> values) {
    if (contains(' ')) {
      final camel = split(' ').sublist(1).map((e) => e.title).join();
      final lower = split(' ')[0];
      final lowerCamel = lower + camel;

      return values.firstWhere((e) => lowerCamel == enumToString(e));
    } else {
      return values.firstWhere((e) => this == enumToString(e));
    }
  }
}

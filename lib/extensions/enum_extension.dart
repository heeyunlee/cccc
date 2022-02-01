import 'package:cccc/extensions/string_extension.dart';

String enumToString<T>(T e) => e.toString().split('.').last;

String enumToTitle<T>(T e) {
  RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');

  final camelCase = enumToString(e);
  final camelToSentence = camelCase.replaceAllMapped(
    exp,
    (m) => ' ' + m.group(0)!,
  );
  final result = camelToSentence.title;

  return result;
}

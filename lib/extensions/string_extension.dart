extension CapExtension on String {
  String get title {
    final split = this.split(' ');
    final iter = split.map((e) => e[0].toUpperCase() + e.substring(1));

    return iter.join(' ');
  }
}

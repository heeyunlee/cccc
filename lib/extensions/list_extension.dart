extension NumListSum on List<num> {
  num get sum {
    var result = 0.0;

    for (final e in this) {
      result += e;
    }

    return result;
  }
}

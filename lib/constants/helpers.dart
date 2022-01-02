String enumToString<T>(T e) => e.toString().split('.').last;

T enumFromString<T>(String str, List<T> values) => values.firstWhere(
      (e) => str == enumToString(e),
    );

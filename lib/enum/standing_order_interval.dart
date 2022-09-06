enum StandingOrderInterval {
  weekly,
  monthly,
}

extension StandingOrderIntervalToString on StandingOrderInterval {
  String get string {
    switch (this) {
      case StandingOrderInterval.weekly:
        return 'WEEKLY';
      case StandingOrderInterval.monthly:
        return 'MONTHLY';
    }
  }
}

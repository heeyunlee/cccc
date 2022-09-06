enum PlaidInstitutionRefreshInterval {
  normal,
  delayed,
  stopped,
  others,
}

extension RefreshIntervalToString on PlaidInstitutionRefreshInterval {
  String get string {
    switch (this) {
      case PlaidInstitutionRefreshInterval.normal:
        return 'NORMAL';
      case PlaidInstitutionRefreshInterval.delayed:
        return 'DELAYED';
      case PlaidInstitutionRefreshInterval.stopped:
        return 'STOPPED';
      case PlaidInstitutionRefreshInterval.others:
        return 'OTHERS';
    }
  }
}

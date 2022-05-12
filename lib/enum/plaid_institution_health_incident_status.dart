enum PlaidInstitutionHealthIncidentStatus {
  investigating,
  identified,
  scheduled,
  resolved,
  unknown,
  others,
}

extension HealthIncidentStatus on PlaidInstitutionHealthIncidentStatus {
  String get string {
    switch (this) {
      case PlaidInstitutionHealthIncidentStatus.investigating:
        return 'INVESTIGATING';
      case PlaidInstitutionHealthIncidentStatus.identified:
        return 'IDENTIFIED';
      case PlaidInstitutionHealthIncidentStatus.scheduled:
        return 'SCHEDULED';
      case PlaidInstitutionHealthIncidentStatus.resolved:
        return 'RESOLVED';
      case PlaidInstitutionHealthIncidentStatus.unknown:
        return 'UNKNOWN';
      case PlaidInstitutionHealthIncidentStatus.others:
        return 'OTHERS';
    }
  }
}

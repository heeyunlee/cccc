import 'dart:convert';

import 'plaid_institution_incident_updates.dart';

/// Details of recent health incidents associated with the institution.
class PlaidInstitutionHealthIncidents {
  const PlaidInstitutionHealthIncidents({
    required this.startDate,
    required this.endDate,
    required this.title,
    required this.incidentUpdates,
  });

  /// The start date of the incident, in ISO 8601 format,
  /// e.g. `2020-10-30T15:26:48Z`.
  final DateTime startDate;

  /// The end date of the incident, in ISO 8601 format,
  /// e.g. `2020-10-30T15:26:48Z`.
  final DateTime endDate;

  /// The title of the incident
  final String title;

  final PlaidInstitutionIncidentUpdates incidentUpdates;

  PlaidInstitutionHealthIncidents copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? title,
    PlaidInstitutionIncidentUpdates? incidentUpdates,
  }) {
    return PlaidInstitutionHealthIncidents(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      title: title ?? this.title,
      incidentUpdates: incidentUpdates ?? this.incidentUpdates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate.millisecondsSinceEpoch,
      'title': title,
      'incident_updates': incidentUpdates.toMap(),
    };
  }

  factory PlaidInstitutionHealthIncidents.fromMap(Map<String, dynamic> map) {
    return PlaidInstitutionHealthIncidents(
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['end_date']),
      title: map['title'] ?? '',
      incidentUpdates:
          PlaidInstitutionIncidentUpdates.fromMap(map['incident_updates']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidInstitutionHealthIncidents.fromJson(String source) =>
      PlaidInstitutionHealthIncidents.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaidInstitutionHealthIncidents(startDate: $startDate, endDate: $endDate, title: $title, incidentUpdates: $incidentUpdates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidInstitutionHealthIncidents &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.title == title &&
        other.incidentUpdates == incidentUpdates;
  }

  @override
  int get hashCode {
    return startDate.hashCode ^
        endDate.hashCode ^
        title.hashCode ^
        incidentUpdates.hashCode;
  }
}

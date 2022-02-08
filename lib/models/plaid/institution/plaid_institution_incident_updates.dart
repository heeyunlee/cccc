import 'dart:convert';

import 'package:cccc/models/enum/plaid_institution_health_incident_status.dart';
import 'package:cccc/extensions/string_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Updates on the health incident.
class PlaidInstitutionIncidentUpdates {
  const PlaidInstitutionIncidentUpdates({
    required this.description,
    required this.status,
    required this.updatedDate,
  });

  /// The content of the update.
  final String description;

  /// The status of the incident.
  final PlaidInstitutionHealthIncidentStatus status;

  /// The date when the update was published, in ISO 8601 format,
  /// e.g. `2020-10-30T15:26:48Z`.
  final DateTime updatedDate;

  PlaidInstitutionIncidentUpdates copyWith({
    String? description,
    PlaidInstitutionHealthIncidentStatus? status,
    DateTime? updatedDate,
  }) {
    return PlaidInstitutionIncidentUpdates(
      description: description ?? this.description,
      status: status ?? this.status,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'status': status.string,
      'updated_date': updatedDate,
    };
  }

  factory PlaidInstitutionIncidentUpdates.fromMap(Map<String, dynamic> map) {
    return PlaidInstitutionIncidentUpdates(
      description: map['description'] ?? '',
      status: (map['status'] as String).healthIncidentStatus,
      updatedDate: (map['updated_date'] as Timestamp).toDate().toUtc(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidInstitutionIncidentUpdates.fromJson(String source) =>
      PlaidInstitutionIncidentUpdates.fromMap(json.decode(source));

  @override
  String toString() =>
      'PlaidInstitutionIncidentUpdates(description: $description, status: $status, updatedDate: $updatedDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidInstitutionIncidentUpdates &&
        other.description == description &&
        other.status == status &&
        other.updatedDate == updatedDate;
  }

  @override
  int get hashCode =>
      description.hashCode ^ status.hashCode ^ updatedDate.hashCode;
}

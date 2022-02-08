import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'plaid_status_breakdown.dart';

/// A representation of the status health of a request type.
///
/// Auth requests, Balance requests, Identity requests, Investments requests,
/// Liabilities requests, Transactions updates, Investments updates, Liabilities updates,
/// and Item logins each have their own status object.
class PlaidItemStatus {
  const PlaidItemStatus({
    required this.lastStatusChange,
    required this.breakdown,
  });

  /// ISO 8601 formatted timestamp of the last status change for the
  /// institution.
  final DateTime lastStatusChange;

  /// A detailed breakdown of the institution's performance for a request type.
  /// The values for success, error_plaid, and error_institution sum to 1.
  final PlaidStatusBreakdown breakdown;

  PlaidItemStatus copyWith({
    DateTime? lastStatusChange,
    PlaidStatusBreakdown? breakdown,
  }) {
    return PlaidItemStatus(
      lastStatusChange: lastStatusChange ?? this.lastStatusChange,
      breakdown: breakdown ?? this.breakdown,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'last_status_change': lastStatusChange.millisecondsSinceEpoch,
      'breakdown': breakdown.toMap(),
    };
  }

  factory PlaidItemStatus.fromMap(Map<String, dynamic> map) {
    return PlaidItemStatus(
      lastStatusChange:
          (map['last_status_change'] as Timestamp).toDate().toUtc(),
      breakdown: PlaidStatusBreakdown.fromMap(map['breakdown']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidItemStatus.fromJson(String source) =>
      PlaidItemStatus.fromMap(json.decode(source));

  @override
  String toString() =>
      'PlaidItemLogins(lastStatusChange: $lastStatusChange, breakdown: $breakdown)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidItemStatus &&
        other.lastStatusChange == lastStatusChange &&
        other.breakdown == breakdown;
  }

  @override
  int get hashCode => lastStatusChange.hashCode ^ breakdown.hashCode;
}

import 'dart:convert';

import 'plaid_institution_health_incidents.dart';
import 'plaid_item_status.dart';

/// The status of an institution is determined by the health of its Item
/// logins, Transactions updates, Investments updates, Liabilities updates,
/// Auth requests, Balance requests, Identity requests, Investments requests,
/// and Liabilities requests. A login attempt is conducted during the initial
/// Item add in Link. If there is not enough traffic to accurately calculate an
/// institution's status, Plaid will return null rather than potentially
/// inaccurate data.
///
/// Institution status is accessible in the Dashboard and via the API using
/// the /institutions/get_by_id endpoint with the include_status option set to
/// true. Note that institution status is not available in the Sandbox
/// environment.
class PlaidInstitutionStatus {
  const PlaidInstitutionStatus({
    required this.itemLogins,
    required this.transactionsUpdates,
    required this.auth,
    required this.identity,
    required this.investmentUpdates,
    required this.liabilitiesUpdates,
    required this.liabilities,
    required this.investments,
    this.healthIncidents,
  });

  /// A representation of the status health of a request type. Auth requests,
  /// Balance requests, Identity requests, Investments requests, Liabilities
  /// requests, Transactions updates, Investments updates, Liabilities updates,
  /// and Item logins each have their own status object.
  final PlaidItemStatus itemLogins;

  /// A representation of the status health of a request type. Auth requests,
  /// Balance requests, Identity requests, Investments requests, Liabilities
  /// requests, Transactions updates, Investments updates, Liabilities updates,
  /// and Item logins each have their own status object.
  final PlaidItemStatus transactionsUpdates;

  /// A representation of the status health of a request type. Auth requests,
  /// Balance requests, Identity requests, Investments requests, Liabilities
  /// requests, Transactions updates, Investments updates, Liabilities updates,
  /// and Item logins each have their own status object.
  final PlaidItemStatus auth;

  /// A representation of the status health of a request type. Auth requests,
  /// Balance requests, Identity requests, Investments requests, Liabilities
  /// requests, Transactions updates, Investments updates, Liabilities updates,
  /// and Item logins each have their own status object.
  final PlaidItemStatus identity;

  /// A representation of the status health of a request type. Auth requests,
  /// Balance requests, Identity requests, Investments requests, Liabilities
  /// requests, Transactions updates, Investments updates, Liabilities updates,
  /// and Item logins each have their own status object.
  final PlaidItemStatus investmentUpdates;

  /// A representation of the status health of a request type. Auth requests,
  /// Balance requests, Identity requests, Investments requests, Liabilities
  /// requests, Transactions updates, Investments updates, Liabilities updates,
  /// and Item logins each have their own status object.
  final PlaidItemStatus liabilitiesUpdates;

  /// A representation of the status health of a request type. Auth requests,
  /// Balance requests, Identity requests, Investments requests, Liabilities
  /// requests, Transactions updates, Investments updates, Liabilities updates,
  ///  and Item logins each have their own status object.
  final PlaidItemStatus liabilities;

  /// A representation of the status health of a request type. Auth requests,
  /// Balance requests, Identity requests, Investments requests, Liabilities
  /// requests, Transactions updates, Investments updates, Liabilities updates,
  /// and Item logins each have their own status object.
  final PlaidItemStatus investments;

  /// Details of recent health incidents associated with the institution.
  final PlaidInstitutionHealthIncidents? healthIncidents;

  PlaidInstitutionStatus copyWith({
    PlaidItemStatus? itemLogins,
    PlaidItemStatus? transactionsUpdates,
    PlaidItemStatus? auth,
    PlaidItemStatus? identity,
    PlaidItemStatus? investmentUpdates,
    PlaidItemStatus? liabilitiesUpdates,
    PlaidItemStatus? liabilities,
    PlaidItemStatus? investments,
    PlaidInstitutionHealthIncidents? healthIncidents,
  }) {
    return PlaidInstitutionStatus(
      itemLogins: itemLogins ?? this.itemLogins,
      transactionsUpdates: transactionsUpdates ?? this.transactionsUpdates,
      auth: auth ?? this.auth,
      identity: identity ?? this.identity,
      investmentUpdates: investmentUpdates ?? this.investmentUpdates,
      liabilitiesUpdates: liabilitiesUpdates ?? this.liabilitiesUpdates,
      liabilities: liabilities ?? this.liabilities,
      investments: investments ?? this.investments,
      healthIncidents: healthIncidents ?? this.healthIncidents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_logins': itemLogins.toMap(),
      'transactions_updates': transactionsUpdates.toMap(),
      'auth': auth.toMap(),
      'identity': identity.toMap(),
      'investment_updates': investmentUpdates.toMap(),
      'liabilities_updates': liabilitiesUpdates.toMap(),
      'liabilities': liabilities.toMap(),
      'investments': investments.toMap(),
      'health_incidents': healthIncidents?.toMap(),
    };
  }

  factory PlaidInstitutionStatus.fromMap(Map<String, dynamic> map) {
    return PlaidInstitutionStatus(
      itemLogins: PlaidItemStatus.fromMap(map['item_logins']),
      transactionsUpdates: PlaidItemStatus.fromMap(map['transactions_updates']),
      auth: PlaidItemStatus.fromMap(map['auth']),
      identity: PlaidItemStatus.fromMap(map['identity']),
      investmentUpdates: PlaidItemStatus.fromMap(map['investment_updates']),
      liabilitiesUpdates: PlaidItemStatus.fromMap(map['liabilities_updates']),
      liabilities: PlaidItemStatus.fromMap(map['liabilities']),
      investments: PlaidItemStatus.fromMap(map['investments']),
      healthIncidents: map['health_incidents'] != null
          ? PlaidInstitutionHealthIncidents.fromMap(map['health_incidents'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidInstitutionStatus.fromJson(String source) =>
      PlaidInstitutionStatus.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaidInstitutionStatus(itemLogins: $itemLogins, transactionsUpdates: $transactionsUpdates, auth: $auth, identity: $identity, investmentUpdates: $investmentUpdates, liabilitiesUpdates: $liabilitiesUpdates, liabilities: $liabilities, investments: $investments, healthIncidents: $healthIncidents)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidInstitutionStatus &&
        other.itemLogins == itemLogins &&
        other.transactionsUpdates == transactionsUpdates &&
        other.auth == auth &&
        other.identity == identity &&
        other.investmentUpdates == investmentUpdates &&
        other.liabilitiesUpdates == liabilitiesUpdates &&
        other.liabilities == liabilities &&
        other.investments == investments &&
        other.healthIncidents == healthIncidents;
  }

  @override
  int get hashCode {
    return itemLogins.hashCode ^
        transactionsUpdates.hashCode ^
        auth.hashCode ^
        identity.hashCode ^
        investmentUpdates.hashCode ^
        liabilitiesUpdates.hashCode ^
        liabilities.hashCode ^
        investments.hashCode ^
        healthIncidents.hashCode;
  }
}

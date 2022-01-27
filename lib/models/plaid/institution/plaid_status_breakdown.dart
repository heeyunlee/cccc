import 'dart:convert';
import 'package:cccc/extensions/string_extension.dart';
import 'package:cccc/models/enum/plaid_institution_refresh_interval.dart';

class PlaidStatusBreakdown {
  const PlaidStatusBreakdown({
    required this.success,
    required this.errorPlaid,
    required this.errorInstitution,
    required this.refreshInterval,
  });

  /// The percentage of login attempts that are successful, expressed as a
  /// decimal.
  final double success;

  /// The percentage of logins that are failing due to an internal Plaid issue,
  /// expressed as a decimal.
  final double errorPlaid;

  /// The percentage of logins that are failing due to an issue in the
  /// institution's system, expressed as a decimal.
  final double errorInstitution;

  /// The refresh_interval may be DELAYED or STOPPED even when the success rate
  /// is high. This value is only returned for Transactions status breakdowns.
  ///
  /// Possible values: NORMAL, DELAYED, STOPPED
  final PlaidInstitutionRefreshInterval refreshInterval;

  PlaidStatusBreakdown copyWith({
    double? success,
    double? errorPlaid,
    double? errorInstitution,
    PlaidInstitutionRefreshInterval? refreshInterval,
  }) {
    return PlaidStatusBreakdown(
      success: success ?? this.success,
      errorPlaid: errorPlaid ?? this.errorPlaid,
      errorInstitution: errorInstitution ?? this.errorInstitution,
      refreshInterval: refreshInterval ?? this.refreshInterval,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'error_plaid': errorPlaid,
      'error_institution': errorInstitution,
      'refresh_interval': refreshInterval.string,
    };
  }

  factory PlaidStatusBreakdown.fromMap(Map<String, dynamic> map) {
    return PlaidStatusBreakdown(
      success: map['success']?.toDouble() ?? 0.0,
      errorPlaid: map['error_plaid']?.toDouble() ?? 0.0,
      errorInstitution: map['error_institution']?.toDouble() ?? 0.0,
      refreshInterval: (map['refresh_interval'] as String).refreshInterval,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidStatusBreakdown.fromJson(String source) =>
      PlaidStatusBreakdown.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaidStatusBreakdown(success: $success, errorPlaid: $errorPlaid, errorInstitution: $errorInstitution, refreshInterval: $refreshInterval)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidStatusBreakdown &&
        other.success == success &&
        other.errorPlaid == errorPlaid &&
        other.errorInstitution == errorInstitution &&
        other.refreshInterval == refreshInterval;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        errorPlaid.hashCode ^
        errorInstitution.hashCode ^
        refreshInterval.hashCode;
  }
}

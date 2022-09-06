import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:cccc/extensions/string_extension.dart';
import 'package:cccc/enum/standing_order_interval.dart';

/// Metadata specifically related to valid Payment Initiation standing order
/// configurations for the institution.
class StandingOrderMetadata {
  const StandingOrderMetadata({
    required this.supportsStandingOrderEndDate,
    required this.supportsStandingOrderNegativeExecutionDays,
    required this.validStandingOrderIntervals,
  });

  /// Indicates whether the institution supports closed-ended standing orders
  /// by providing an end date.
  final bool supportsStandingOrderEndDate;

  /// This is only applicable to MONTHLY standing orders. Indicates whether
  /// the institution supports negative integers (-1 to -5) for setting up a
  /// MONTHLY standing order relative to the end of the month.
  final bool supportsStandingOrderNegativeExecutionDays;

  /// A list of the valid standing order intervals supported by the institution.
  ///
  /// Possible values: WEEKLY, MONTHLY
  /// Min length: 1
  final List<StandingOrderInterval> validStandingOrderIntervals;

  StandingOrderMetadata copyWith({
    bool? supportsStandingOrderEndDate,
    bool? supportsStandingOrderNegativeExecutionDays,
    List<StandingOrderInterval>? validStandingOrderIntervals,
  }) {
    return StandingOrderMetadata(
      supportsStandingOrderEndDate:
          supportsStandingOrderEndDate ?? this.supportsStandingOrderEndDate,
      supportsStandingOrderNegativeExecutionDays:
          supportsStandingOrderNegativeExecutionDays ??
              this.supportsStandingOrderNegativeExecutionDays,
      validStandingOrderIntervals:
          validStandingOrderIntervals ?? this.validStandingOrderIntervals,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supports_standing_order_end_date': supportsStandingOrderEndDate,
      'supports_standing_order_negative_execution_days':
          supportsStandingOrderNegativeExecutionDays,
      'valid_standing_order_intervals':
          validStandingOrderIntervals.map((x) => x.string).toList(),
    };
  }

  factory StandingOrderMetadata.fromMap(Map<String, dynamic> map) {
    return StandingOrderMetadata(
      supportsStandingOrderEndDate:
          map['supports_standing_order_end_date'] ?? false,
      supportsStandingOrderNegativeExecutionDays:
          map['supports_standing_order_negative_execution_days'] ?? false,
      validStandingOrderIntervals: List<StandingOrderInterval>.from(
          map['valid_standing_order_intervals']
              ?.map((x) => (x as String).standingOrderInterval)),
    );
  }

  String toJson() => json.encode(toMap());

  factory StandingOrderMetadata.fromJson(String source) =>
      StandingOrderMetadata.fromMap(json.decode(source));

  @override
  String toString() =>
      'StandingOrderMetadata(supportsStandingOrderEndDate: $supportsStandingOrderEndDate, supportsStandingOrderNegativeExecutionDays: $supportsStandingOrderNegativeExecutionDays, validStandingOrderIntervals: $validStandingOrderIntervals)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StandingOrderMetadata &&
        other.supportsStandingOrderEndDate == supportsStandingOrderEndDate &&
        other.supportsStandingOrderNegativeExecutionDays ==
            supportsStandingOrderNegativeExecutionDays &&
        listEquals(
            other.validStandingOrderIntervals, validStandingOrderIntervals);
  }

  @override
  int get hashCode =>
      supportsStandingOrderEndDate.hashCode ^
      supportsStandingOrderNegativeExecutionDays.hashCode ^
      validStandingOrderIntervals.hashCode;
}

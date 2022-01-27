import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'standing_order_metadata.dart';

/// Metadata that captures what specific payment configurations an institution
/// supports when making Payment Initiation requests.
class PaymentInitiationMetadata {
  const PaymentInitiationMetadata({
    required this.supportsInternationalPayments,
    required this.maximumPaymentAmount,
    required this.supportsRefundDetails,
    this.standingOrderMetadata,
  });

  /// Indicates whether the institution supports payments from a different
  /// country.
  final bool supportsInternationalPayments;

  /// A mapping of currency to maximum payment amount (denominated in the
  /// smallest unit of currency) supported by the institution.
  ///
  /// Example: {"GBP": "10000"}
  final Map<String, dynamic> maximumPaymentAmount;

  /// Indicates whether the institution supports returning refund details when
  /// initiating a payment.
  final bool supportsRefundDetails;

  /// Metadata specifically related to valid Payment Initiation standing order
  /// configurations for the institution.
  final StandingOrderMetadata? standingOrderMetadata;

  PaymentInitiationMetadata copyWith({
    bool? supportsInternationalPayments,
    Map<String, dynamic>? maximumPaymentAmount,
    bool? supportsRefundDetails,
    StandingOrderMetadata? standingOrderMetadata,
  }) {
    return PaymentInitiationMetadata(
      supportsInternationalPayments:
          supportsInternationalPayments ?? this.supportsInternationalPayments,
      maximumPaymentAmount: maximumPaymentAmount ?? this.maximumPaymentAmount,
      supportsRefundDetails:
          supportsRefundDetails ?? this.supportsRefundDetails,
      standingOrderMetadata:
          standingOrderMetadata ?? this.standingOrderMetadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supports_international_payments': supportsInternationalPayments,
      'maximum_payment_amount': maximumPaymentAmount,
      'supports_refund_details': supportsRefundDetails,
      'standing_order_metadata': standingOrderMetadata?.toMap(),
    };
  }

  factory PaymentInitiationMetadata.fromMap(Map<String, dynamic> map) {
    return PaymentInitiationMetadata(
      supportsInternationalPayments:
          map['supports_international_payments'] ?? false,
      maximumPaymentAmount:
          Map<String, dynamic>.from(map['maximum_payment_amount']),
      supportsRefundDetails: map['supports_refund_details'] ?? false,
      standingOrderMetadata: map['standing_order_metadata'] != null
          ? StandingOrderMetadata.fromMap(map['standing_order_metadata'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentInitiationMetadata.fromJson(String source) =>
      PaymentInitiationMetadata.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PaymentInitiationMetadata(supportsInternationalPayments: $supportsInternationalPayments, maximumPaymentAmount: $maximumPaymentAmount, supportsRefundDetails: $supportsRefundDetails, standingOrderMetadata: $standingOrderMetadata)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentInitiationMetadata &&
        other.supportsInternationalPayments == supportsInternationalPayments &&
        mapEquals(other.maximumPaymentAmount, maximumPaymentAmount) &&
        other.supportsRefundDetails == supportsRefundDetails &&
        other.standingOrderMetadata == standingOrderMetadata;
  }

  @override
  int get hashCode {
    return supportsInternationalPayments.hashCode ^
        maximumPaymentAmount.hashCode ^
        supportsRefundDetails.hashCode ^
        standingOrderMetadata.hashCode;
  }
}

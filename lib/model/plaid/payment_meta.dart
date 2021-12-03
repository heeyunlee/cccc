import 'dart:convert';

/// Transaction information specific to inter-bank transfers.
/// If the transaction was not an inter-bank transfer, all fields will be null.
///
/// If the transactions object was returned by a Transactions endpoint such
/// as `/transactions/get`, the payment_meta key will always appear, but no data
/// elements are guaranteed. If the transactions object was returned by an
/// Assets endpoint such as `/asset_report/get/` or `/asset_report/pdf/get`,
/// this field will only appear in an Asset Report with Insights.
class PaymentMeta {
  PaymentMeta({
    this.referenceNumber,
    this.ppdId,
    this.payee,
    this.byOrderOf,
    this.payer,
    this.paymentMethod,
    this.paymentProcessor,
    this.reason,
  });

  /// The transaction reference number supplied by the financial institution.
  final String? referenceNumber;

  /// The ACH PPD ID for the payer.
  final String? ppdId;

  /// For transfers, the party that is receiving the transaction.
  final String? payee;

  /// The party initiating a wire transfer. Will be null if the transaction
  /// is not a wire transfer.
  final String? byOrderOf;

  /// For transfers, the party that is paying the transaction.
  final String? payer;

  /// The type of transfer, e.g. 'ACH'
  final String? paymentMethod;

  /// The name of the payment processor
  final String? paymentProcessor;

  /// The payer-supplied description of the transfer.
  final String? reason;

  PaymentMeta copyWith({
    String? referenceNumber,
    String? ppdId,
    String? payee,
    String? byOrderOf,
    String? payer,
    String? paymentMethod,
    String? paymentProcessor,
    String? reason,
  }) {
    return PaymentMeta(
      referenceNumber: referenceNumber ?? this.referenceNumber,
      ppdId: ppdId ?? this.ppdId,
      payee: payee ?? this.payee,
      byOrderOf: byOrderOf ?? this.byOrderOf,
      payer: payer ?? this.payer,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentProcessor: paymentProcessor ?? this.paymentProcessor,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'referenceNumber': referenceNumber,
      'ppdId': ppdId,
      'payee': payee,
      'byOrderOf': byOrderOf,
      'payer': payer,
      'paymentMethod': paymentMethod,
      'paymentProcessor': paymentProcessor,
      'reason': reason,
    };
  }

  factory PaymentMeta.fromMap(Map<String, dynamic> map) {
    return PaymentMeta(
      referenceNumber:
          map['referenceNumber'] != null ? map['referenceNumber'] : null,
      ppdId: map['ppdId'] != null ? map['ppdId'] : null,
      payee: map['payee'] != null ? map['payee'] : null,
      byOrderOf: map['byOrderOf'] != null ? map['byOrderOf'] : null,
      payer: map['payer'] != null ? map['payer'] : null,
      paymentMethod: map['paymentMethod'] != null ? map['paymentMethod'] : null,
      paymentProcessor:
          map['paymentProcessor'] != null ? map['paymentProcessor'] : null,
      reason: map['reason'] != null ? map['reason'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMeta.fromJson(String source) =>
      PaymentMeta.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PaymentMeta(referenceNumber: $referenceNumber, ppdId: $ppdId, payee: $payee, byOrderOf: $byOrderOf, payer: $payer, paymentMethod: $paymentMethod, paymentProcessor: $paymentProcessor, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentMeta &&
        other.referenceNumber == referenceNumber &&
        other.ppdId == ppdId &&
        other.payee == payee &&
        other.byOrderOf == byOrderOf &&
        other.payer == payer &&
        other.paymentMethod == paymentMethod &&
        other.paymentProcessor == paymentProcessor &&
        other.reason == reason;
  }

  @override
  int get hashCode {
    return referenceNumber.hashCode ^
        ppdId.hashCode ^
        payee.hashCode ^
        byOrderOf.hashCode ^
        payer.hashCode ^
        paymentMethod.hashCode ^
        paymentProcessor.hashCode ^
        reason.hashCode;
  }
}

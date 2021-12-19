import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_meta.freezed.dart';
part 'payment_meta.g.dart';

/// Transaction information specific to inter-bank transfers.
/// If the transaction was not an inter-bank transfer, all fields will be null.
///
/// If the transactions object was returned by a Transactions endpoint such
/// as `/transactions/get`, the payment_meta key will always appear, but no data
/// elements are guaranteed. If the transactions object was returned by an
/// Assets endpoint such as `/asset_report/get/` or `/asset_report/pdf/get`,
/// this field will only appear in an Asset Report with Insights.
@Freezed()
class PaymentMeta with _$PaymentMeta {
  const factory PaymentMeta({
    /// The transaction reference number supplied by the financial institution.
    String? referenceNumber,

    /// The ACH PPD ID for the payer.
    String? ppdId,

    /// For transfers, the party that is receiving the transaction.
    String? payee,

    /// The party initiating a wire transfer. Will be null if the transaction
    /// is not a wire transfer.
    String? byOrderOf,

    /// For transfers, the party that is paying the transaction.
    String? payer,

    /// The type of transfer, e.g. 'ACH'
    String? paymentMethod,

    /// The name of the payment processor
    String? paymentProcessor,

    /// The payer-supplied description of the transfer.
    String? reason,
  }) = _PaymentMeta;

  factory PaymentMeta.fromJson(Map<String, dynamic> json) =>
      _$PaymentMetaFromJson(json);
}

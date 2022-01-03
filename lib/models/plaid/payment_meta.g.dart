// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PaymentMeta _$$_PaymentMetaFromJson(Map<String, dynamic> json) =>
    _$_PaymentMeta(
      referenceNumber: json['referenceNumber'] as String?,
      ppdId: json['ppdId'] as String?,
      payee: json['payee'] as String?,
      byOrderOf: json['byOrderOf'] as String?,
      payer: json['payer'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      paymentProcessor: json['paymentProcessor'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$_PaymentMetaToJson(_$_PaymentMeta instance) =>
    <String, dynamic>{
      'referenceNumber': instance.referenceNumber,
      'ppdId': instance.ppdId,
      'payee': instance.payee,
      'byOrderOf': instance.byOrderOf,
      'payer': instance.payer,
      'paymentMethod': instance.paymentMethod,
      'paymentProcessor': instance.paymentProcessor,
      'reason': instance.reason,
    };

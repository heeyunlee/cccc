// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PaymentMeta _$PaymentMetaFromJson(Map<String, dynamic> json) {
  return _PaymentMeta.fromJson(json);
}

/// @nodoc
mixin _$PaymentMeta {
  /// The transaction reference number supplied by the financial institution.
  String? get referenceNumber => throw _privateConstructorUsedError;

  /// The ACH PPD ID for the payer.
  String? get ppdId => throw _privateConstructorUsedError;

  /// For transfers, the party that is receiving the transaction.
  String? get payee => throw _privateConstructorUsedError;

  /// The party initiating a wire transfer. Will be null if the transaction
  /// is not a wire transfer.
  String? get byOrderOf => throw _privateConstructorUsedError;

  /// For transfers, the party that is paying the transaction.
  String? get payer => throw _privateConstructorUsedError;

  /// The type of transfer, e.g. 'ACH'
  String? get paymentMethod => throw _privateConstructorUsedError;

  /// The name of the payment processor
  String? get paymentProcessor => throw _privateConstructorUsedError;

  /// The payer-supplied description of the transfer.
  String? get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentMetaCopyWith<PaymentMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMetaCopyWith<$Res> {
  factory $PaymentMetaCopyWith(
          PaymentMeta value, $Res Function(PaymentMeta) then) =
      _$PaymentMetaCopyWithImpl<$Res, PaymentMeta>;
  @useResult
  $Res call(
      {String? referenceNumber,
      String? ppdId,
      String? payee,
      String? byOrderOf,
      String? payer,
      String? paymentMethod,
      String? paymentProcessor,
      String? reason});
}

/// @nodoc
class _$PaymentMetaCopyWithImpl<$Res, $Val extends PaymentMeta>
    implements $PaymentMetaCopyWith<$Res> {
  _$PaymentMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referenceNumber = freezed,
    Object? ppdId = freezed,
    Object? payee = freezed,
    Object? byOrderOf = freezed,
    Object? payer = freezed,
    Object? paymentMethod = freezed,
    Object? paymentProcessor = freezed,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      ppdId: freezed == ppdId
          ? _value.ppdId
          : ppdId // ignore: cast_nullable_to_non_nullable
              as String?,
      payee: freezed == payee
          ? _value.payee
          : payee // ignore: cast_nullable_to_non_nullable
              as String?,
      byOrderOf: freezed == byOrderOf
          ? _value.byOrderOf
          : byOrderOf // ignore: cast_nullable_to_non_nullable
              as String?,
      payer: freezed == payer
          ? _value.payer
          : payer // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentProcessor: freezed == paymentProcessor
          ? _value.paymentProcessor
          : paymentProcessor // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PaymentMetaCopyWith<$Res>
    implements $PaymentMetaCopyWith<$Res> {
  factory _$$_PaymentMetaCopyWith(
          _$_PaymentMeta value, $Res Function(_$_PaymentMeta) then) =
      __$$_PaymentMetaCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? referenceNumber,
      String? ppdId,
      String? payee,
      String? byOrderOf,
      String? payer,
      String? paymentMethod,
      String? paymentProcessor,
      String? reason});
}

/// @nodoc
class __$$_PaymentMetaCopyWithImpl<$Res>
    extends _$PaymentMetaCopyWithImpl<$Res, _$_PaymentMeta>
    implements _$$_PaymentMetaCopyWith<$Res> {
  __$$_PaymentMetaCopyWithImpl(
      _$_PaymentMeta _value, $Res Function(_$_PaymentMeta) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referenceNumber = freezed,
    Object? ppdId = freezed,
    Object? payee = freezed,
    Object? byOrderOf = freezed,
    Object? payer = freezed,
    Object? paymentMethod = freezed,
    Object? paymentProcessor = freezed,
    Object? reason = freezed,
  }) {
    return _then(_$_PaymentMeta(
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      ppdId: freezed == ppdId
          ? _value.ppdId
          : ppdId // ignore: cast_nullable_to_non_nullable
              as String?,
      payee: freezed == payee
          ? _value.payee
          : payee // ignore: cast_nullable_to_non_nullable
              as String?,
      byOrderOf: freezed == byOrderOf
          ? _value.byOrderOf
          : byOrderOf // ignore: cast_nullable_to_non_nullable
              as String?,
      payer: freezed == payer
          ? _value.payer
          : payer // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentProcessor: freezed == paymentProcessor
          ? _value.paymentProcessor
          : paymentProcessor // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PaymentMeta implements _PaymentMeta {
  const _$_PaymentMeta(
      {this.referenceNumber,
      this.ppdId,
      this.payee,
      this.byOrderOf,
      this.payer,
      this.paymentMethod,
      this.paymentProcessor,
      this.reason});

  factory _$_PaymentMeta.fromJson(Map<String, dynamic> json) =>
      _$$_PaymentMetaFromJson(json);

  /// The transaction reference number supplied by the financial institution.
  @override
  final String? referenceNumber;

  /// The ACH PPD ID for the payer.
  @override
  final String? ppdId;

  /// For transfers, the party that is receiving the transaction.
  @override
  final String? payee;

  /// The party initiating a wire transfer. Will be null if the transaction
  /// is not a wire transfer.
  @override
  final String? byOrderOf;

  /// For transfers, the party that is paying the transaction.
  @override
  final String? payer;

  /// The type of transfer, e.g. 'ACH'
  @override
  final String? paymentMethod;

  /// The name of the payment processor
  @override
  final String? paymentProcessor;

  /// The payer-supplied description of the transfer.
  @override
  final String? reason;

  @override
  String toString() {
    return 'PaymentMeta(referenceNumber: $referenceNumber, ppdId: $ppdId, payee: $payee, byOrderOf: $byOrderOf, payer: $payer, paymentMethod: $paymentMethod, paymentProcessor: $paymentProcessor, reason: $reason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PaymentMeta &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.ppdId, ppdId) || other.ppdId == ppdId) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.byOrderOf, byOrderOf) ||
                other.byOrderOf == byOrderOf) &&
            (identical(other.payer, payer) || other.payer == payer) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentProcessor, paymentProcessor) ||
                other.paymentProcessor == paymentProcessor) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, referenceNumber, ppdId, payee,
      byOrderOf, payer, paymentMethod, paymentProcessor, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PaymentMetaCopyWith<_$_PaymentMeta> get copyWith =>
      __$$_PaymentMetaCopyWithImpl<_$_PaymentMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PaymentMetaToJson(
      this,
    );
  }
}

abstract class _PaymentMeta implements PaymentMeta {
  const factory _PaymentMeta(
      {final String? referenceNumber,
      final String? ppdId,
      final String? payee,
      final String? byOrderOf,
      final String? payer,
      final String? paymentMethod,
      final String? paymentProcessor,
      final String? reason}) = _$_PaymentMeta;

  factory _PaymentMeta.fromJson(Map<String, dynamic> json) =
      _$_PaymentMeta.fromJson;

  @override

  /// The transaction reference number supplied by the financial institution.
  String? get referenceNumber;
  @override

  /// The ACH PPD ID for the payer.
  String? get ppdId;
  @override

  /// For transfers, the party that is receiving the transaction.
  String? get payee;
  @override

  /// The party initiating a wire transfer. Will be null if the transaction
  /// is not a wire transfer.
  String? get byOrderOf;
  @override

  /// For transfers, the party that is paying the transaction.
  String? get payer;
  @override

  /// The type of transfer, e.g. 'ACH'
  String? get paymentMethod;
  @override

  /// The name of the payment processor
  String? get paymentProcessor;
  @override

  /// The payer-supplied description of the transfer.
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$_PaymentMetaCopyWith<_$_PaymentMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

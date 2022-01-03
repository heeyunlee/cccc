// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'payment_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PaymentMeta _$PaymentMetaFromJson(Map<String, dynamic> json) {
  return _PaymentMeta.fromJson(json);
}

/// @nodoc
class _$PaymentMetaTearOff {
  const _$PaymentMetaTearOff();

  _PaymentMeta call(
      {String? referenceNumber,
      String? ppdId,
      String? payee,
      String? byOrderOf,
      String? payer,
      String? paymentMethod,
      String? paymentProcessor,
      String? reason}) {
    return _PaymentMeta(
      referenceNumber: referenceNumber,
      ppdId: ppdId,
      payee: payee,
      byOrderOf: byOrderOf,
      payer: payer,
      paymentMethod: paymentMethod,
      paymentProcessor: paymentProcessor,
      reason: reason,
    );
  }

  PaymentMeta fromJson(Map<String, Object?> json) {
    return PaymentMeta.fromJson(json);
  }
}

/// @nodoc
const $PaymentMeta = _$PaymentMetaTearOff();

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
      _$PaymentMetaCopyWithImpl<$Res>;
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
class _$PaymentMetaCopyWithImpl<$Res> implements $PaymentMetaCopyWith<$Res> {
  _$PaymentMetaCopyWithImpl(this._value, this._then);

  final PaymentMeta _value;
  // ignore: unused_field
  final $Res Function(PaymentMeta) _then;

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
      referenceNumber: referenceNumber == freezed
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      ppdId: ppdId == freezed
          ? _value.ppdId
          : ppdId // ignore: cast_nullable_to_non_nullable
              as String?,
      payee: payee == freezed
          ? _value.payee
          : payee // ignore: cast_nullable_to_non_nullable
              as String?,
      byOrderOf: byOrderOf == freezed
          ? _value.byOrderOf
          : byOrderOf // ignore: cast_nullable_to_non_nullable
              as String?,
      payer: payer == freezed
          ? _value.payer
          : payer // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: paymentMethod == freezed
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentProcessor: paymentProcessor == freezed
          ? _value.paymentProcessor
          : paymentProcessor // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: reason == freezed
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$PaymentMetaCopyWith<$Res>
    implements $PaymentMetaCopyWith<$Res> {
  factory _$PaymentMetaCopyWith(
          _PaymentMeta value, $Res Function(_PaymentMeta) then) =
      __$PaymentMetaCopyWithImpl<$Res>;
  @override
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
class __$PaymentMetaCopyWithImpl<$Res> extends _$PaymentMetaCopyWithImpl<$Res>
    implements _$PaymentMetaCopyWith<$Res> {
  __$PaymentMetaCopyWithImpl(
      _PaymentMeta _value, $Res Function(_PaymentMeta) _then)
      : super(_value, (v) => _then(v as _PaymentMeta));

  @override
  _PaymentMeta get _value => super._value as _PaymentMeta;

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
    return _then(_PaymentMeta(
      referenceNumber: referenceNumber == freezed
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      ppdId: ppdId == freezed
          ? _value.ppdId
          : ppdId // ignore: cast_nullable_to_non_nullable
              as String?,
      payee: payee == freezed
          ? _value.payee
          : payee // ignore: cast_nullable_to_non_nullable
              as String?,
      byOrderOf: byOrderOf == freezed
          ? _value.byOrderOf
          : byOrderOf // ignore: cast_nullable_to_non_nullable
              as String?,
      payer: payer == freezed
          ? _value.payer
          : payer // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: paymentMethod == freezed
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentProcessor: paymentProcessor == freezed
          ? _value.paymentProcessor
          : paymentProcessor // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: reason == freezed
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

  @override

  /// The transaction reference number supplied by the financial institution.
  final String? referenceNumber;
  @override

  /// The ACH PPD ID for the payer.
  final String? ppdId;
  @override

  /// For transfers, the party that is receiving the transaction.
  final String? payee;
  @override

  /// The party initiating a wire transfer. Will be null if the transaction
  /// is not a wire transfer.
  final String? byOrderOf;
  @override

  /// For transfers, the party that is paying the transaction.
  final String? payer;
  @override

  /// The type of transfer, e.g. 'ACH'
  final String? paymentMethod;
  @override

  /// The name of the payment processor
  final String? paymentProcessor;
  @override

  /// The payer-supplied description of the transfer.
  final String? reason;

  @override
  String toString() {
    return 'PaymentMeta(referenceNumber: $referenceNumber, ppdId: $ppdId, payee: $payee, byOrderOf: $byOrderOf, payer: $payer, paymentMethod: $paymentMethod, paymentProcessor: $paymentProcessor, reason: $reason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PaymentMeta &&
            const DeepCollectionEquality()
                .equals(other.referenceNumber, referenceNumber) &&
            const DeepCollectionEquality().equals(other.ppdId, ppdId) &&
            const DeepCollectionEquality().equals(other.payee, payee) &&
            const DeepCollectionEquality().equals(other.byOrderOf, byOrderOf) &&
            const DeepCollectionEquality().equals(other.payer, payer) &&
            const DeepCollectionEquality()
                .equals(other.paymentMethod, paymentMethod) &&
            const DeepCollectionEquality()
                .equals(other.paymentProcessor, paymentProcessor) &&
            const DeepCollectionEquality().equals(other.reason, reason));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(referenceNumber),
      const DeepCollectionEquality().hash(ppdId),
      const DeepCollectionEquality().hash(payee),
      const DeepCollectionEquality().hash(byOrderOf),
      const DeepCollectionEquality().hash(payer),
      const DeepCollectionEquality().hash(paymentMethod),
      const DeepCollectionEquality().hash(paymentProcessor),
      const DeepCollectionEquality().hash(reason));

  @JsonKey(ignore: true)
  @override
  _$PaymentMetaCopyWith<_PaymentMeta> get copyWith =>
      __$PaymentMetaCopyWithImpl<_PaymentMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PaymentMetaToJson(this);
  }
}

abstract class _PaymentMeta implements PaymentMeta {
  const factory _PaymentMeta(
      {String? referenceNumber,
      String? ppdId,
      String? payee,
      String? byOrderOf,
      String? payer,
      String? paymentMethod,
      String? paymentProcessor,
      String? reason}) = _$_PaymentMeta;

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
  _$PaymentMetaCopyWith<_PaymentMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'plaid_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PlaidLocation _$PlaidLocationFromJson(Map<String, dynamic> json) {
  return _PlaidLocation.fromJson(json);
}

/// @nodoc
mixin _$PlaidLocation {
  /// The street address where the transaction occurred.
  String? get address => throw _privateConstructorUsedError;

  /// The city where the transaction occurred.
  String? get city => throw _privateConstructorUsedError;

  /// The region or state where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called state.
  String? get region => throw _privateConstructorUsedError;

  /// The postal code where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called zip.
  String? get postalCode => throw _privateConstructorUsedError;

  /// The ISO 3166-1 alpha-2 country code where the transaction occurred.
  String? get country => throw _privateConstructorUsedError;

  /// The latitude where the transaction occurred.
  double? get lat => throw _privateConstructorUsedError;

  /// The longitude where the transaction occurred.
  double? get lon => throw _privateConstructorUsedError;

  /// The merchant defined store number where the transaction occurred.
  String? get storeNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaidLocationCopyWith<PlaidLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaidLocationCopyWith<$Res> {
  factory $PlaidLocationCopyWith(
          PlaidLocation value, $Res Function(PlaidLocation) then) =
      _$PlaidLocationCopyWithImpl<$Res, PlaidLocation>;
  @useResult
  $Res call(
      {String? address,
      String? city,
      String? region,
      String? postalCode,
      String? country,
      double? lat,
      double? lon,
      String? storeNumber});
}

/// @nodoc
class _$PlaidLocationCopyWithImpl<$Res, $Val extends PlaidLocation>
    implements $PlaidLocationCopyWith<$Res> {
  _$PlaidLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? city = freezed,
    Object? region = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? storeNumber = freezed,
  }) {
    return _then(_value.copyWith(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      storeNumber: freezed == storeNumber
          ? _value.storeNumber
          : storeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PlaidLocationCopyWith<$Res>
    implements $PlaidLocationCopyWith<$Res> {
  factory _$$_PlaidLocationCopyWith(
          _$_PlaidLocation value, $Res Function(_$_PlaidLocation) then) =
      __$$_PlaidLocationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? address,
      String? city,
      String? region,
      String? postalCode,
      String? country,
      double? lat,
      double? lon,
      String? storeNumber});
}

/// @nodoc
class __$$_PlaidLocationCopyWithImpl<$Res>
    extends _$PlaidLocationCopyWithImpl<$Res, _$_PlaidLocation>
    implements _$$_PlaidLocationCopyWith<$Res> {
  __$$_PlaidLocationCopyWithImpl(
      _$_PlaidLocation _value, $Res Function(_$_PlaidLocation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? city = freezed,
    Object? region = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? storeNumber = freezed,
  }) {
    return _then(_$_PlaidLocation(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      storeNumber: freezed == storeNumber
          ? _value.storeNumber
          : storeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PlaidLocation implements _PlaidLocation {
  const _$_PlaidLocation(
      {this.address,
      this.city,
      this.region,
      this.postalCode,
      this.country,
      this.lat,
      this.lon,
      this.storeNumber});

  factory _$_PlaidLocation.fromJson(Map<String, dynamic> json) =>
      _$$_PlaidLocationFromJson(json);

  /// The street address where the transaction occurred.
  @override
  final String? address;

  /// The city where the transaction occurred.
  @override
  final String? city;

  /// The region or state where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called state.
  @override
  final String? region;

  /// The postal code where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called zip.
  @override
  final String? postalCode;

  /// The ISO 3166-1 alpha-2 country code where the transaction occurred.
  @override
  final String? country;

  /// The latitude where the transaction occurred.
  @override
  final double? lat;

  /// The longitude where the transaction occurred.
  @override
  final double? lon;

  /// The merchant defined store number where the transaction occurred.
  @override
  final String? storeNumber;

  @override
  String toString() {
    return 'PlaidLocation(address: $address, city: $city, region: $region, postalCode: $postalCode, country: $country, lat: $lat, lon: $lon, storeNumber: $storeNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlaidLocation &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.storeNumber, storeNumber) ||
                other.storeNumber == storeNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, address, city, region,
      postalCode, country, lat, lon, storeNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlaidLocationCopyWith<_$_PlaidLocation> get copyWith =>
      __$$_PlaidLocationCopyWithImpl<_$_PlaidLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PlaidLocationToJson(
      this,
    );
  }
}

abstract class _PlaidLocation implements PlaidLocation {
  const factory _PlaidLocation(
      {final String? address,
      final String? city,
      final String? region,
      final String? postalCode,
      final String? country,
      final double? lat,
      final double? lon,
      final String? storeNumber}) = _$_PlaidLocation;

  factory _PlaidLocation.fromJson(Map<String, dynamic> json) =
      _$_PlaidLocation.fromJson;

  @override

  /// The street address where the transaction occurred.
  String? get address;
  @override

  /// The city where the transaction occurred.
  String? get city;
  @override

  /// The region or state where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called state.
  String? get region;
  @override

  /// The postal code where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called zip.
  String? get postalCode;
  @override

  /// The ISO 3166-1 alpha-2 country code where the transaction occurred.
  String? get country;
  @override

  /// The latitude where the transaction occurred.
  double? get lat;
  @override

  /// The longitude where the transaction occurred.
  double? get lon;
  @override

  /// The merchant defined store number where the transaction occurred.
  String? get storeNumber;
  @override
  @JsonKey(ignore: true)
  _$$_PlaidLocationCopyWith<_$_PlaidLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

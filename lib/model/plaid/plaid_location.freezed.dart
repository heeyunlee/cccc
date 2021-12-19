// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'plaid_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PlaidLocation _$PlaidLocationFromJson(Map<String, dynamic> json) {
  return _PlaidLocation.fromJson(json);
}

/// @nodoc
class _$PlaidLocationTearOff {
  const _$PlaidLocationTearOff();

  _PlaidLocation call(
      {String? address,
      String? city,
      String? region,
      String? postalCode,
      String? country,
      double? lat,
      double? lon,
      String? storeNumber}) {
    return _PlaidLocation(
      address: address,
      city: city,
      region: region,
      postalCode: postalCode,
      country: country,
      lat: lat,
      lon: lon,
      storeNumber: storeNumber,
    );
  }

  PlaidLocation fromJson(Map<String, Object?> json) {
    return PlaidLocation.fromJson(json);
  }
}

/// @nodoc
const $PlaidLocation = _$PlaidLocationTearOff();

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
      _$PlaidLocationCopyWithImpl<$Res>;
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
class _$PlaidLocationCopyWithImpl<$Res>
    implements $PlaidLocationCopyWith<$Res> {
  _$PlaidLocationCopyWithImpl(this._value, this._then);

  final PlaidLocation _value;
  // ignore: unused_field
  final $Res Function(PlaidLocation) _then;

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
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: city == freezed
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      region: region == freezed
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: postalCode == freezed
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: country == freezed
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      storeNumber: storeNumber == freezed
          ? _value.storeNumber
          : storeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$PlaidLocationCopyWith<$Res>
    implements $PlaidLocationCopyWith<$Res> {
  factory _$PlaidLocationCopyWith(
          _PlaidLocation value, $Res Function(_PlaidLocation) then) =
      __$PlaidLocationCopyWithImpl<$Res>;
  @override
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
class __$PlaidLocationCopyWithImpl<$Res>
    extends _$PlaidLocationCopyWithImpl<$Res>
    implements _$PlaidLocationCopyWith<$Res> {
  __$PlaidLocationCopyWithImpl(
      _PlaidLocation _value, $Res Function(_PlaidLocation) _then)
      : super(_value, (v) => _then(v as _PlaidLocation));

  @override
  _PlaidLocation get _value => super._value as _PlaidLocation;

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
    return _then(_PlaidLocation(
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: city == freezed
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      region: region == freezed
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: postalCode == freezed
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: country == freezed
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      storeNumber: storeNumber == freezed
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

  @override

  /// The street address where the transaction occurred.
  final String? address;
  @override

  /// The city where the transaction occurred.
  final String? city;
  @override

  /// The region or state where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called state.
  final String? region;
  @override

  /// The postal code where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called zip.
  final String? postalCode;
  @override

  /// The ISO 3166-1 alpha-2 country code where the transaction occurred.
  final String? country;
  @override

  /// The latitude where the transaction occurred.
  final double? lat;
  @override

  /// The longitude where the transaction occurred.
  final double? lon;
  @override

  /// The merchant defined store number where the transaction occurred.
  final String? storeNumber;

  @override
  String toString() {
    return 'PlaidLocation(address: $address, city: $city, region: $region, postalCode: $postalCode, country: $country, lat: $lat, lon: $lon, storeNumber: $storeNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlaidLocation &&
            const DeepCollectionEquality().equals(other.address, address) &&
            const DeepCollectionEquality().equals(other.city, city) &&
            const DeepCollectionEquality().equals(other.region, region) &&
            const DeepCollectionEquality()
                .equals(other.postalCode, postalCode) &&
            const DeepCollectionEquality().equals(other.country, country) &&
            const DeepCollectionEquality().equals(other.lat, lat) &&
            const DeepCollectionEquality().equals(other.lon, lon) &&
            const DeepCollectionEquality()
                .equals(other.storeNumber, storeNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(address),
      const DeepCollectionEquality().hash(city),
      const DeepCollectionEquality().hash(region),
      const DeepCollectionEquality().hash(postalCode),
      const DeepCollectionEquality().hash(country),
      const DeepCollectionEquality().hash(lat),
      const DeepCollectionEquality().hash(lon),
      const DeepCollectionEquality().hash(storeNumber));

  @JsonKey(ignore: true)
  @override
  _$PlaidLocationCopyWith<_PlaidLocation> get copyWith =>
      __$PlaidLocationCopyWithImpl<_PlaidLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PlaidLocationToJson(this);
  }
}

abstract class _PlaidLocation implements PlaidLocation {
  const factory _PlaidLocation(
      {String? address,
      String? city,
      String? region,
      String? postalCode,
      String? country,
      double? lat,
      double? lon,
      String? storeNumber}) = _$_PlaidLocation;

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
  _$PlaidLocationCopyWith<_PlaidLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

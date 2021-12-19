import 'package:freezed_annotation/freezed_annotation.dart';

part 'plaid_location.freezed.dart';
part 'plaid_location.g.dart';

/// A representation of where a transaction took place
@Freezed()
class PlaidLocation with _$PlaidLocation {
  const factory PlaidLocation({
    /// The street address where the transaction occurred.
    String? address,

    /// The city where the transaction occurred.
    String? city,

    /// The region or state where the transaction occurred.
    /// In API versions 2018-05-22 and earlier, this field is called state.
    String? region,

    /// The postal code where the transaction occurred.
    /// In API versions 2018-05-22 and earlier, this field is called zip.
    String? postalCode,

    /// The ISO 3166-1 alpha-2 country code where the transaction occurred.
    String? country,

    /// The latitude where the transaction occurred.
    double? lat,

    /// The longitude where the transaction occurred.
    double? lon,

    /// The merchant defined store number where the transaction occurred.
    String? storeNumber,
  }) = _PlaidLocation;

  factory PlaidLocation.fromJson(Map<String, dynamic> json) =>
      _$PlaidLocationFromJson(json);
}

import 'dart:convert';

/// A representation of where a transaction took place
class PlaidLocation {
  PlaidLocation({
    this.address,
    this.city,
    this.region,
    this.postalCode,
    this.country,
    this.lat,
    this.lon,
    this.storeNumber,
  });

  /// The street address where the transaction occurred.
  final String? address;

  /// The city where the transaction occurred.
  final String? city;

  /// The region or state where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called state.
  final String? region;

  /// The postal code where the transaction occurred.
  /// In API versions 2018-05-22 and earlier, this field is called zip.
  final String? postalCode;

  /// The ISO 3166-1 alpha-2 country code where the transaction occurred.
  final String? country;

  /// The latitude where the transaction occurred.
  final double? lat;

  /// The longitude where the transaction occurred.
  final double? lon;

  /// The merchant defined store number where the transaction occurred.
  final String? storeNumber;

  PlaidLocation copyWith({
    String? address,
    String? city,
    String? region,
    String? postalCode,
    String? country,
    double? lat,
    double? lon,
    String? storeNumber,
  }) {
    return PlaidLocation(
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      storeNumber: storeNumber ?? this.storeNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'region': region,
      'postalCode': postalCode,
      'country': country,
      'lat': lat,
      'lon': lon,
      'storeNumber': storeNumber,
    };
  }

  factory PlaidLocation.fromMap(Map<String, dynamic> map) {
    final String? address = map['address'];
    final String? city = map['city'];
    final String? region = map['region'];
    final String? postalCode = map['postal_code'];
    final String? country = map['country'];
    final double? lat = map['lat'];
    final double? lon = map['lon'];
    final String? storeNumber = map['store_number'];

    return PlaidLocation(
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

  String toJson() => json.encode(toMap());

  factory PlaidLocation.fromJson(String source) =>
      PlaidLocation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaidLocation(address: $address, city: $city, region: $region, postalCode: $postalCode, country: $country, lat: $lat, lon: $lon, storeNumber: $storeNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidLocation &&
        other.address == address &&
        other.city == city &&
        other.region == region &&
        other.postalCode == postalCode &&
        other.country == country &&
        other.lat == lat &&
        other.lon == lon &&
        other.storeNumber == storeNumber;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        city.hashCode ^
        region.hashCode ^
        postalCode.hashCode ^
        country.hashCode ^
        lat.hashCode ^
        lon.hashCode ^
        storeNumber.hashCode;
  }
}

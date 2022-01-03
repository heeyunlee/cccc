// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plaid_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PlaidLocation _$$_PlaidLocationFromJson(Map<String, dynamic> json) =>
    _$_PlaidLocation(
      address: json['address'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      storeNumber: json['storeNumber'] as String?,
    );

Map<String, dynamic> _$$_PlaidLocationToJson(_$_PlaidLocation instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'region': instance.region,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'lat': instance.lat,
      'lon': instance.lon,
      'storeNumber': instance.storeNumber,
    };

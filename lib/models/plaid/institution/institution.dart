import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cccc/extensions/string_extension.dart';
import 'package:cccc/models/enum/plaid_product.dart';
import 'package:cccc/models/plaid/institution/auth_metadata.dart';
import 'package:cccc/models/plaid/institution/payment_initiation_metadata.dart';
import 'package:cccc/models/plaid/institution/plaid_institution_status.dart';

/// A list of Plaid institutions
class Institution {
  const Institution({
    required this.institutionId,
    required this.name,
    required this.products,
    required this.countryCodes,
    this.url,
    this.primaryColor,
    this.logo,
    required this.routingNumbers,
    required this.oauth,
    this.status,
    this.paymentInitiationMetadata,
    this.authMetadata,
  });

  /// Unique identifier for the institution
  final String institutionId;

  /// The official name of the institution
  final String name;

  /// A list of the Plaid products supported by the institution. Note that
  /// only institutions that support Instant Auth will return auth in the
  /// product array; institutions that do not list auth may still support
  /// other Auth methods such as Instant Match or Automated Micro-deposit
  /// Verification. For more details, see Full Auth
  /// [coverage](https://plaid.com/docs/auth/coverage/).
  ///
  /// Possible values: `assets`, `auth`, `balance`, `identity`, `investments`,
  /// `liabilities`, `payment_initiation`, `transactions`, `credit_details`,
  /// `income`, `income_verification`, `deposit_switch`, `standing_orders`,
  /// `transfer`, `employment`
  final List<PlaidProduct> products;

  /// A list of the country codes supported by the institution.
  ///
  /// Possible values: US, GB, ES, NL, FR, IE, CA, DE
  final List<String> countryCodes;

  /// The URL for the institution's website
  final String? url;

  /// Hexadecimal representation of the primary color used by the institution
  final String? primaryColor;

  /// Base64 encoded representation of the institution's logo
  final String? logo;

  /// A partial list of routing numbers associated with the institution. This
  /// list is provided for the purpose of looking up institutions by routing
  /// number. It is not comprehensive and should never be used as a complete
  /// list of routing numbers for an institution.
  final List<String> routingNumbers;

  /// Indicates that the institution has an OAuth login flow. This is
  /// primarily relevant to institutions with European country codes.
  final bool oauth;

  /// The status of an institution is determined by the health of its Item
  /// logins, Transactions updates, Investments updates, Liabilities updates,
  /// Auth requests, Balance requests, Identity requests, Investments requests,
  ///  and Liabilities requests. A login attempt is conducted during the
  /// initial Item add in Link. If there is not enough traffic to accurately
  /// calculate an institution's status, Plaid will return null rather than
  /// potentially inaccurate data.
  ///
  /// Institution status is accessible in the Dashboard and via the API using
  /// the /institutions/get_by_id endpoint with the include_status option set
  /// to true. Note that institution status is not available in the Sandbox
  /// environment.
  final PlaidInstitutionStatus? status;

  /// Metadata that captures what specific payment configurations an
  /// institution supports when making Payment Initiation requests.
  final PaymentInitiationMetadata? paymentInitiationMetadata;

  /// Metadata that captures information about the Auth features of an
  /// institution.
  final AuthMetadata? authMetadata;

  Institution copyWith({
    String? institutionId,
    String? name,
    List<PlaidProduct>? products,
    List<String>? countryCodes,
    String? url,
    String? primaryColor,
    String? logo,
    List<String>? routingNumbers,
    bool? oauth,
    PlaidInstitutionStatus? status,
    PaymentInitiationMetadata? paymentInitiationMetadata,
    AuthMetadata? authMetadata,
  }) {
    return Institution(
      institutionId: institutionId ?? this.institutionId,
      name: name ?? this.name,
      products: products ?? this.products,
      countryCodes: countryCodes ?? this.countryCodes,
      url: url ?? this.url,
      primaryColor: primaryColor ?? this.primaryColor,
      logo: logo ?? this.logo,
      routingNumbers: routingNumbers ?? this.routingNumbers,
      oauth: oauth ?? this.oauth,
      status: status ?? this.status,
      paymentInitiationMetadata:
          paymentInitiationMetadata ?? this.paymentInitiationMetadata,
      authMetadata: authMetadata ?? this.authMetadata,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'institution_id': institutionId,
      'name': name,
      'products': products.map((x) => x.string).toList(),
      'country_codes': countryCodes,
      'url': url,
      'primary_color': primaryColor,
      'logo': logo,
      'routing_numbers': routingNumbers,
      'oauth': oauth,
      'status': status?.toMap(),
      'payment_initiation_metadata': paymentInitiationMetadata?.toMap(),
      'auth_metadata': authMetadata?.toMap(),
    };
  }

  factory Institution.fromMap(Map<String, dynamic> map) {
    return Institution(
      institutionId: map['institution_id'] ?? '',
      name: map['name'] ?? '',
      products: List<PlaidProduct>.from(
          map['products']?.map((x) => (x as String).plaidProduct)),
      countryCodes: List<String>.from(map['country_codes']),
      url: map['url'],
      primaryColor: map['primary_color'],
      logo: map['logo'],
      routingNumbers: List<String>.from(map['routing_numbers']),
      oauth: map['oauth'] ?? false,
      status: map['status'] != null
          ? PlaidInstitutionStatus.fromMap(map['status'])
          : null,
      paymentInitiationMetadata: map['payment_initiation_metadata'] != null
          ? PaymentInitiationMetadata.fromMap(
              map['payment_initiation_metadata'])
          : null,
      authMetadata: map['auth_metadata'] != null
          ? AuthMetadata.fromMap(map['auth_metadata'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Institution.fromJson(String source) =>
      Institution.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Institution(institutionId: $institutionId, name: $name, products: $products, countryCodes: $countryCodes, url: $url, primaryColor: $primaryColor, logo: $logo, routingNumbers: $routingNumbers, oauth: $oauth, status: $status, paymentInitiationMetadata: $paymentInitiationMetadata, authMetadata: $authMetadata)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Institution &&
        other.institutionId == institutionId &&
        other.name == name &&
        listEquals(other.products, products) &&
        listEquals(other.countryCodes, countryCodes) &&
        other.url == url &&
        other.primaryColor == primaryColor &&
        other.logo == logo &&
        listEquals(other.routingNumbers, routingNumbers) &&
        other.oauth == oauth &&
        other.status == status &&
        other.paymentInitiationMetadata == paymentInitiationMetadata &&
        other.authMetadata == authMetadata;
  }

  @override
  int get hashCode {
    return institutionId.hashCode ^
        name.hashCode ^
        products.hashCode ^
        countryCodes.hashCode ^
        url.hashCode ^
        primaryColor.hashCode ^
        logo.hashCode ^
        routingNumbers.hashCode ^
        oauth.hashCode ^
        status.hashCode ^
        paymentInitiationMetadata.hashCode ^
        authMetadata.hashCode;
  }
}

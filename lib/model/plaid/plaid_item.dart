import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cccc/model/plaid/plaid_error.dart';

/// Metadata about the Item.
class PlaidItem {
  PlaidItem({
    required this.itemId,
    this.institutionId,
    this.webhook,
    this.error,
    required this.availableProducts,
    required this.billedProducts,
    required this.products,
    this.consentExpirationTime,
    required this.updateType,
  });

  /// The Plaid Item ID. The `item_id` is always unique; linking the same
  /// account at the same institution twice will result in two Items with
  /// different `item_id` values. Like all Plaid identifiers, the `item_id` is
  /// case-sensitive.
  final String itemId;

  /// The Plaid Institution ID associated with the Item. Field is `null` for
  /// Items created via Same Day Micro-deposits.
  final String? institutionId;

  /// The URL registered to receive webhooks for the Item.
  final String? webhook;

  /// We use standard HTTP response codes for success and failure
  /// notifications, and our errors are further classified by `error_type`.
  /// In general, 200 HTTP codes correspond to success, 40X codes are for
  /// developer- or user-related failures, and 50X codes are for
  /// Plaid-related issues.  Error fields will be `null` if no error has
  /// occurred.
  final PlaidError? error;

  /// A list of products available for the Item that have not yet been accessed.
  ///
  /// Possible values: `assets`, `auth`, `balance`, `identity`, `investments`,
  /// `liabilities`, `payment_initiation`, `transactions`, `credit_details`,
  /// `income`, `income_verification`, `deposit_switch`, `standing_orders`,
  /// `transfer`
  final List<String> availableProducts;

  /// A list of products that have been billed for the Item. Note -
  /// `billed_products` is populated in all environments but only requests in
  /// Production are billed.
  ///
  /// Possible values: `assets`, `auth`, `balance`, `identity`, `investments`,
  /// `liabilities`, `payment_initiation`, `transactions`, `credit_details`,
  /// `income`, `income_verification`, `deposit_switch`, `standing_orders`,
  /// `transfer`
  final List<String> billedProducts;

  /// A list of authorized products for the Item.
  ///
  /// Possible values: `assets`, `auth`, `balance`, `identity`, `investments`,
  /// `liabilities`, `payment_initiation`, `transactions`, `credit_details`,
  /// `income`, `income_verification`, `deposit_switch`, `standing_orders`,
  /// `transfer`
  final List<String> products;

  /// The RFC 3339 timestamp after which the consent provided by the end user
  /// will expire. Upon consent expiration, the item will enter the
  /// `ITEM_LOGIN_REQUIRED` error state. To circumvent the `ITEM_LOGIN_REQUIRED`
  /// error and maintain continuous consent, the end user can reauthenticate
  /// via Link’s update mode in advance of the consent expiration time.
  ///
  /// Note - This is only relevant for certain OAuth-based institutions.
  /// For all other institutions, this field will be `null`.
  ///
  /// Format: `date-time`
  final String? consentExpirationTime;

  /// Indicates whether an Item requires user interaction to be updated, which
  /// can be the case for Items with some forms of two-factor authentication.
  ///
  /// `background` - Item can be updated in the background
  ///
  /// `user_present_required` - Item requires user interaction to be updated
  ///
  /// Possible values: `background`, `user_present_required`
  final String updateType;

  PlaidItem copyWith({
    String? itemId,
    String? institutionId,
    String? webhook,
    PlaidError? error,
    List<String>? availableProducts,
    List<String>? billedProducts,
    List<String>? products,
    String? consentExpirationTime,
    String? updateType,
  }) {
    return PlaidItem(
      itemId: itemId ?? this.itemId,
      institutionId: institutionId ?? this.institutionId,
      webhook: webhook ?? this.webhook,
      error: error ?? this.error,
      availableProducts: availableProducts ?? this.availableProducts,
      billedProducts: billedProducts ?? this.billedProducts,
      products: products ?? this.products,
      consentExpirationTime:
          consentExpirationTime ?? this.consentExpirationTime,
      updateType: updateType ?? this.updateType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'institutionId': institutionId,
      'webhook': webhook,
      'error': error?.toMap(),
      'availableProducts': availableProducts,
      'billedProducts': billedProducts,
      'products': products,
      'consentExpirationTime': consentExpirationTime,
      'updateType': updateType,
    };
  }

  factory PlaidItem.fromMap(Map<String, dynamic> map) {
    final String itemId = map['item_id'];
    final String? institutionId = map['institution_id'];
    final String? webhook = map['webhook'];
    final PlaidError? error =
        map['error'] != null ? PlaidError.fromMap(map['error']) : null;
    final List<String> availableProducts =
        List<String>.from(map['available_products']);
    final List<String> billedProducts =
        List<String>.from(map['billed_products']);
    final List<String> products = List<String>.from(map['products']);
    final String? consentExpirationTime = map['consent_expiration_time'];
    final String updateType = map['update_type'];

    return PlaidItem(
      itemId: itemId,
      institutionId: institutionId,
      webhook: webhook,
      error: error,
      availableProducts: availableProducts,
      billedProducts: billedProducts,
      products: products,
      consentExpirationTime: consentExpirationTime,
      updateType: updateType,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidItem.fromJson(String source) =>
      PlaidItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaidItem(itemId: $itemId, institutionId: $institutionId, webhook: $webhook, error: $error, availableProducts: $availableProducts, billedProducts: $billedProducts, products: $products, consentExpirationTime: $consentExpirationTime, updateType: $updateType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidItem &&
        other.itemId == itemId &&
        other.institutionId == institutionId &&
        other.webhook == webhook &&
        other.error == error &&
        listEquals(other.availableProducts, availableProducts) &&
        listEquals(other.billedProducts, billedProducts) &&
        listEquals(other.products, products) &&
        other.consentExpirationTime == consentExpirationTime &&
        other.updateType == updateType;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^
        institutionId.hashCode ^
        webhook.hashCode ^
        error.hashCode ^
        availableProducts.hashCode ^
        billedProducts.hashCode ^
        products.hashCode ^
        consentExpirationTime.hashCode ^
        updateType.hashCode;
  }
}

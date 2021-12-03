import 'dart:convert';

import 'package:flutter/foundation.dart';

/// We use standard HTTP response codes for success and failure notifications,
/// and our errors are further classified by error_type. In general, 200 HTTP
/// codes correspond to success, 40X codes are for developer- or user-related
/// failures, and 50X codes are for Plaid-related issues.  Error fields will
/// be null if no error has occurred.
class PlaidError {
  PlaidError({
    required this.errorType,
    required this.errorCode,
    required this.errorMessage,
    this.displayMessage,
    required this.requestId,
    required this.causes,
    this.status,
    required this.documentationUrl,
    required this.suggestedAction,
  });

  /// A broad categorization of the error. Safe for programatic use.
  ///
  /// Possible values: `INVALID_REQUEST`, `INVALID_RESULT`, `INVALID_INPUT`,
  /// `INSTITUTION_ERROR`, `RATE_LIMIT_EXCEEDED`, `API_ERROR`, `ITEM_ERROR`,
  /// `ASSET_REPORT_ERROR`, `RECAPTCHA_ERROR`, `OAUTH_ERROR`, `PAYMENT_ERROR`,
  /// `BANK_TRANSFER_ERROR`, `INCOME_VERIFICATION_ERROR`
  final String errorType;

  /// The particular error code. Safe for programmatic use.
  final String errorCode;

  /// A developer-friendly representation of the error code. This may change
  /// over time and is not safe for programmatic use.
  final String errorMessage;

  /// A user-friendly representation of the error code. null if the error is
  /// not related to user action.
  ///
  /// This may change over time and is not safe for programmatic use.
  final String? displayMessage;

  /// A unique ID identifying the request, to be used for troubleshooting
  /// purposes. This field will be omitted in errors provided by webhooks.
  final String requestId;

  /// In the Assets product, a request can pertain to more than one Item. If
  /// an error is returned for such a request, causes will return an array of
  /// errors containing a breakdown of these errors on the individual Item
  /// level, if any can be identified.
  ///
  /// causes will only be provided for the `error_type` `ASSET_REPORT_ERROR`.
  /// causes will also not be populated inside an error nested within a
  /// warning object.
  final List causes;

  /// The HTTP status code associated with the error. This will only be
  /// returned in the response body when the error information is provided via
  /// a webhook.
  final num? status;

  /// The URL of a Plaid documentation page with more information about the
  /// error
  final String documentationUrl;

  /// Suggested steps for resolving the error
  final String suggestedAction;

  PlaidError copyWith({
    String? errorType,
    String? errorCode,
    String? errorMessage,
    String? displayMessage,
    String? requestId,
    List? causes,
    num? status,
    String? documentationUrl,
    String? suggestedAction,
  }) {
    return PlaidError(
      errorType: errorType ?? this.errorType,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      displayMessage: displayMessage ?? this.displayMessage,
      requestId: requestId ?? this.requestId,
      causes: causes ?? this.causes,
      status: status ?? this.status,
      documentationUrl: documentationUrl ?? this.documentationUrl,
      suggestedAction: suggestedAction ?? this.suggestedAction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'errorType': errorType,
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'displayMessage': displayMessage,
      'requestId': requestId,
      'causes': causes,
      'status': status,
      'documentationUrl': documentationUrl,
      'suggestedAction': suggestedAction,
    };
  }

  factory PlaidError.fromMap(Map<String, dynamic> map) {
    return PlaidError(
      errorType: map['errorType'],
      errorCode: map['errorCode'],
      errorMessage: map['errorMessage'],
      displayMessage:
          map['displayMessage'] != null ? map['displayMessage'] : null,
      requestId: map['requestId'],
      causes: List.from(map['causes']),
      status: map['status'] != null ? map['status'] : null,
      documentationUrl: map['documentationUrl'],
      suggestedAction: map['suggestedAction'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaidError.fromJson(String source) =>
      PlaidError.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaidError(errorType: $errorType, errorCode: $errorCode, errorMessage: $errorMessage, displayMessage: $displayMessage, requestId: $requestId, causes: $causes, status: $status, documentationUrl: $documentationUrl, suggestedAction: $suggestedAction)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaidError &&
        other.errorType == errorType &&
        other.errorCode == errorCode &&
        other.errorMessage == errorMessage &&
        other.displayMessage == displayMessage &&
        other.requestId == requestId &&
        listEquals(other.causes, causes) &&
        other.status == status &&
        other.documentationUrl == documentationUrl &&
        other.suggestedAction == suggestedAction;
  }

  @override
  int get hashCode {
    return errorType.hashCode ^
        errorCode.hashCode ^
        errorMessage.hashCode ^
        displayMessage.hashCode ^
        requestId.hashCode ^
        causes.hashCode ^
        status.hashCode ^
        documentationUrl.hashCode ^
        suggestedAction.hashCode;
  }
}

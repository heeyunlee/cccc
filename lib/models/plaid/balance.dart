import 'dart:convert';

/// A set of fields describing the balance for an account. Balance information
/// may be cached unless the balance object was returned by
/// `/accounts/balance/get`.
class Balance {
  Balance({
    this.available,
    this.current,
    this.limit,
    this.isoCurrencyCode,
    this.unofficialCurrencyCode,
    this.lastUpdatedDatetime,
  });

  /// The amount of funds available to be withdrawn from the account, as
  /// determined by the financial institution.
  ///
  /// For credit-type accounts, the available balance typically equals the
  /// limit less the current balance, less any pending outflows plus any
  /// pending inflows.
  ///
  /// For depository-type accounts, the available balance typically equals the
  /// current balance less any pending outflows plus any pending inflows. For
  /// `depository-type` accounts, the available balance does not include the
  /// overdraft limit.
  ///
  /// For investment-type accounts (or brokerage-type accounts for API versions
  /// 2018-05-22 and earlier), the available balance is the total cash
  /// available to withdraw as presented by the institution.
  ///
  /// Note that not all institutions calculate the available  balance. In the
  /// event that `available` balance is unavailable, Plaid will return an
  /// available balance value of `null`.
  ///
  /// Available balance may be cached and is not guaranteed to be
  /// up-to-date in realtime unless the value was returned by
  /// `/accounts/balance/get`.
  ///
  /// If current is null this field is guaranteed not to be `null`.
  final num? available;

  /// The total amount of funds in or owed by the account.
  ///
  /// For `credit-`type accounts, a positive balance indicates the amount owed;
  /// a negative amount indicates the lender owing the account holder.
  ///
  /// For `loan-`type accounts, the current balance is the principal remaining
  /// on the loan, except in the case of student loan accounts at Sallie Mae
  /// (ins_116944). For Sallie Mae student loans, the account's balance
  /// includes both principal and any outstanding interest.
  ///
  /// For `investment-`type accounts (or brokerage-type accounts for API
  /// versions 2018-05-22 and earlier), the current balance is the total value
  /// of assets as presented by the institution.
  ///
  /// Note that balance information may be cached unless the value was returned
  /// by `/accounts/balance/get`; if the Item is enabled for Transactions, the
  /// balance will be at least as recent as the most recent Transaction update.
  /// If you require realtime balance information, use the available balance
  /// as provided by `/accounts/balance/get`.
  ///
  /// When returned by `/accounts/balance/get`, this field may be `null`. When
  /// this happens, `available` is guaranteed not to be `null`.
  final num? current;

  /// For `credit-`type accounts, this represents the credit limit.
  ///
  /// For `depository-`type accounts, this represents the pre-arranged
  /// overdraft limit, which is common for current (checking) accounts in
  /// Europe.
  ///
  /// In North America, this field is typically only available for
  /// `credit-`type accounts.
  final num? limit;

  /// The ISO-4217 currency code of the balance. Always null if
  /// `unofficial_currency_code` is non-`null`.
  final String? isoCurrencyCode;

  /// The unofficial currency code associated with the balance. Always null
  /// if iso_currency_code is non-`null`. Unofficial currency codes are used
  /// for currencies that do not have official ISO currency codes, such as
  /// cryptocurrencies and the currencies of certain countries.
  ///
  /// See the [currency code schema]('https://plaid.com/docs/api/accounts/#currency-code-schema')
  /// for a full listing of supported `unofficial_currency_codes`.
  final String? unofficialCurrencyCode;

  /// Timestamp in [ISO 8601]('https://en.wikipedia.org/wiki/ISO_8601')
  /// format (YYYY-MM-DDTHH:mm:ssZ) indicating the last time that the balance
  /// for the given account has been updated
  ///
  /// This is currently only provided when the `min_last_updated_datetime` is
  /// passed when calling `/accounts/balance/get` for `ins_128026` (Capital
  /// One).
  ///
  /// Format: `date-time`
  final String? lastUpdatedDatetime;

  Balance copyWith({
    num? available,
    num? current,
    num? limit,
    String? isoCurrencyCode,
    String? unofficialCurrencyCode,
    String? lastUpdatedDatetime,
  }) {
    return Balance(
      available: available ?? this.available,
      current: current ?? this.current,
      limit: limit ?? this.limit,
      isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
      unofficialCurrencyCode:
          unofficialCurrencyCode ?? this.unofficialCurrencyCode,
      lastUpdatedDatetime: lastUpdatedDatetime ?? this.lastUpdatedDatetime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'available': available,
      'current': current,
      'limit': limit,
      'isoCurrencyCode': isoCurrencyCode,
      'unofficialCurrencyCode': unofficialCurrencyCode,
      'lastUpdatedDatetime': lastUpdatedDatetime,
    };
  }

  factory Balance.fromMap(Map<String, dynamic> map) {
    final num? available = map['available'];
    final num? current = map['current'];
    final num? limit = map['limit'];
    final String? isoCurrenyCode = map['iso_currency_code'];
    final String? unofficialCurrencyCode = map['unofficial_currency_codes'];
    final String? lastUpdatedDatetime = map['last_updated_datetime'];

    return Balance(
      available: available,
      current: current,
      limit: limit,
      isoCurrencyCode: isoCurrenyCode,
      unofficialCurrencyCode: unofficialCurrencyCode,
      lastUpdatedDatetime: lastUpdatedDatetime,
    );
  }

  String toJson() => json.encode(toMap());

  factory Balance.fromJson(String source) =>
      Balance.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Balance(available: $available, current: $current, limit: $limit, isoCurrencyCode: $isoCurrencyCode, unofficialCurrencyCode: $unofficialCurrencyCode, lastUpdatedDatetime: $lastUpdatedDatetime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Balance &&
        other.available == available &&
        other.current == current &&
        other.limit == limit &&
        other.isoCurrencyCode == isoCurrencyCode &&
        other.unofficialCurrencyCode == unofficialCurrencyCode &&
        other.lastUpdatedDatetime == lastUpdatedDatetime;
  }

  @override
  int get hashCode {
    return available.hashCode ^
        current.hashCode ^
        limit.hashCode ^
        isoCurrencyCode.hashCode ^
        unofficialCurrencyCode.hashCode ^
        lastUpdatedDatetime.hashCode;
  }
}

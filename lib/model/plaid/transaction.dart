import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'plaid_location.dart';
import 'payment_meta.dart';
import 'personal_finance_category.dart';

/// An array containing transactions from the account. Transactions are
/// returned in reverse chronological order, with the most recent at the
/// beginning of the array. The maximum number of transactions returned is
/// determined by the count parameter.
class Transaction {
  Transaction({
    this.pendingTransactionId,
    this.categoryId,
    this.category,
    required this.location,
    required this.paymentMeta,
    this.accountOwner,
    required this.name,
    this.originalDescription,
    required this.accountId,
    required this.amount,
    this.isoCurrencyCode,
    this.unofficialCurrencyCode,
    required this.date,
    required this.pending,
    required this.transactionId,
    this.merchantName,
    this.checkNumber,
    required this.paymentChannel,
    this.authorizedDate,
    this.authorizedDatetime,
    this.datetime,
    this.transactionCode,
    this.personalFinanceCategory,
  });

  /// The ID of a posted transaction's associated pending transaction, where
  /// applicable.
  final String? pendingTransactionId;

  /// The ID of the category to which this transaction belongs. See
  /// [Categories]('https://plaid.com/docs/api/products/#categoriesget').
  ///
  /// If the transactions object was returned by an Assets endpoint such as
  /// `/asset_report/get/` or `/asset_report/pdf/get`, this field will only
  /// appear in an Asset Report with Insights.
  final String? categoryId;

  /// A hierarchical array of the categories to which this transaction belongs.
  /// See [Categories]('https://plaid.com/docs/api/products/#categoriesget').
  ///
  /// If the transactions object was returned by an Assets endpoint such as
  /// `/asset_report/get/` or `/asset_report/pdf/get`, this field will only
  /// appear in an Asset Report with Insights.
  final List<String>? category;

  /// A representation of where a transaction took place
  final PlaidLocation location;

  /// Transaction information specific to inter-bank transfers. If the
  /// transaction was not an inter-bank transfer, all fields will be `null`.
  ///
  /// If the transactions object was returned by a Transactions endpoint such
  /// as `/transactions/get`, the payment_meta key will always appear, but no
  /// data elements are guaranteed. If the transactions object was returned by
  /// an Assets endpoint such as `/asset_report/get/` or
  /// `/asset_report/pdf/get`, this field will only appear in an Asset Report
  /// with Insights.
  final PaymentMeta paymentMeta;

  /// The name of the account owner. This field is not typically populated
  /// and only relevant when dealing with sub-accounts.
  final String? accountOwner;

  /// The merchant name or transaction description.
  ///
  /// If the transactions object was returned by a Transactions endpoint such
  /// as `/transactions/get`, this field will always appear. If the
  /// transactions object was returned by an Assets endpoint such as
  /// `/asset_report/get/` or `/asset_report/pdf/get`, this field will only
  /// appear in an Asset Report with Insights.
  final String name;

  /// The string returned by the financial institution to describe the
  /// transaction. For transactions returned by `/transactions/get`, this field
  ///  is in beta and will be omitted unless the client is both enrolled in
  /// the closed beta program and has set `options.include_original_description`
  /// to `true`.
  final String? originalDescription;

  /// The ID of the account in which this transaction occurred.
  final String accountId;

  /// The settled value of the transaction, denominated in the account's
  /// currency, as stated in `iso_currency_code` or `unofficial_currency_code`.
  /// Positive values when money moves out of the account; negative values when
  /// money moves in. For example, debit card purchases are positive; credit
  /// card payments, direct deposits, and refunds are negative.
  final num amount;

  /// The ISO-4217 currency code of the transaction. Always `null` if
  /// `unofficial_currency_code` is non-null.
  final String? isoCurrencyCode;

  /// The unofficial currency code associated with the transaction. Always
  /// null if `iso_currency_code` is non-null. Unofficial currency codes are
  /// used for currencies that do not have official ISO currency codes, such as
  /// cryptocurrencies and the currencies of certain countries.
  ///
  /// See the [currency code schema]('https://plaid.com/docs/api/accounts/#currency-code-schema')
  /// for a full listing of supported
  /// `iso_currency_codes`.
  final String? unofficialCurrencyCode;

  /// For pending transactions, the date that the transaction occurred; for
  /// posted transactions, the date that the transaction posted. Both dates are
  /// returned in an [ISO 8601]('https://en.wikipedia.org/wiki/ISO_8601')
  /// format ( `YYYY-MM-DD` ).
  ///
  /// Format: `date`
  final String date;

  /// When true, identifies the transaction as pending or unsettled. Pending
  /// transaction details (name, type, amount, category ID) may change before
  /// they are settled.
  final bool pending;

  /// The unique ID of the transaction. Like all Plaid identifiers, the
  /// `transaction_id` is case sensitive.
  final String transactionId;

  /// The merchant name, as extracted by Plaid from the name field.
  final String? merchantName;

  /// The check number of the transaction. This field is only populated for
  /// check transactions.
  final String? checkNumber;

  /// The channel used to make a payment.
  /// `online`: transactions that took place online.
  ///
  /// `in store`: transactions that were made at a physical location.
  ///
  /// `other`: transactions that relate to banks, e.g. fees or deposits.
  ///
  /// This field replaces the `transaction_type` field.
  ///
  /// Possible values: `online`, in store, other
  final String paymentChannel;

  /// The date that the transaction was authorized. Dates are returned in an
  /// [ISO 8601]('https://en.wikipedia.org/wiki/ISO_8601') ( `YYYY-MM-DD` ).
  ///
  /// Format: `date`
  final String? authorizedDate;

  /// Date and time when a transaction was authorized in
  /// [ISO 8601]('https://en.wikipedia.org/wiki/ISO_8601')
  /// ( `YYYY-MM-DDTHH:mm:ssZ` ).
  ///
  /// This field is only populated for UK institutions. For institutions in
  /// other countries, will be null.
  ///
  /// Format: `date-time`
  final String? authorizedDatetime;

  /// Date and time when a transaction was posted in
  /// [ISO 8601]('https://en.wikipedia.org/wiki/ISO_8601')
  /// ( `YYYY-MM-DDTHH:mm:ssZ` ).
  ///
  /// This field is only populated for UK institutions. For institutions in
  /// other countries, will be null.
  ///
  /// Format: `date-time`
  final String? datetime;

  /// An identifier classifying the transaction type.
  ///
  /// This field is only populated for European institutions. For institutions
  /// in the US and Canada, this field is set to `null`.
  ///
  /// `adjustment`: Bank adjustment
  ///
  /// `atm`: Cash deposit or withdrawal via an automated teller machine
  ///
  /// `bank charge`: Charge or fee levied by the institution
  ///
  /// `bill payment`: Payment of a bill
  ///
  /// `cash`: Cash deposit or withdrawal
  ///
  /// `cashback`: Cash withdrawal while making a debit card purchase
  ///
  /// `cheque`: Document ordering the payment of money to another person or
  /// organization
  ///
  /// `direct debit`: Automatic withdrawal of funds initiated by a third party
  /// at a regular interval
  ///
  /// `interest`: Interest earned or incurred
  ///
  /// `purchase`: Purchase made with a debit or credit card
  ///
  /// `standing order`: Payment instructed by the account holder to a third
  /// party at a regular interval
  ///
  /// `transfer`: Transfer of money between accounts
  ///
  /// Possible values: `adjustment`, `atm`, `bank charge`, `bill payment`,
  /// `cash`, `cashback`, `cheque`, `direct debit`, `interest`, `purchase`,
  /// `standing order`, `transfer`, `null`
  final String? transactionCode;

  /// Information describing the intent of the transaction. Most relevant for
  /// personal finance use cases, but not limited to such use cases.
  /// The field is currently in beta.
  ///
  /// The complete category can be generated by concatenating primary and
  /// detailed categories.
  ///
  /// This feature is currently in beta – to request access, contact
  /// transactions-feedback@plaid.com.
  final PersonalFinanceCategory? personalFinanceCategory;

  Transaction copyWith({
    String? pendingTransactionId,
    String? categoryId,
    List<String>? category,
    PlaidLocation? location,
    PaymentMeta? paymentMeta,
    String? accountOwner,
    String? name,
    String? originalDescription,
    String? accountId,
    num? amount,
    String? isoCurrencyCode,
    String? unofficialCurrencyCode,
    String? date,
    bool? pending,
    String? transactionId,
    String? merchantName,
    String? checkNumber,
    String? paymentChannel,
    String? authorizedDate,
    String? authorizedDatetime,
    String? datetime,
    String? transactionCode,
    PersonalFinanceCategory? personalFinanceCategory,
  }) {
    return Transaction(
      pendingTransactionId: pendingTransactionId ?? this.pendingTransactionId,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      location: location ?? this.location,
      paymentMeta: paymentMeta ?? this.paymentMeta,
      accountOwner: accountOwner ?? this.accountOwner,
      name: name ?? this.name,
      originalDescription: originalDescription ?? this.originalDescription,
      accountId: accountId ?? this.accountId,
      amount: amount ?? this.amount,
      isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
      unofficialCurrencyCode:
          unofficialCurrencyCode ?? this.unofficialCurrencyCode,
      date: date ?? this.date,
      pending: pending ?? this.pending,
      transactionId: transactionId ?? this.transactionId,
      merchantName: merchantName ?? this.merchantName,
      checkNumber: checkNumber ?? this.checkNumber,
      paymentChannel: paymentChannel ?? this.paymentChannel,
      authorizedDate: authorizedDate ?? this.authorizedDate,
      authorizedDatetime: authorizedDatetime ?? this.authorizedDatetime,
      datetime: datetime ?? this.datetime,
      transactionCode: transactionCode ?? this.transactionCode,
      personalFinanceCategory:
          personalFinanceCategory ?? this.personalFinanceCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pendingTransactionId': pendingTransactionId,
      'categoryId': categoryId,
      'category': category,
      'location': location.toMap(),
      'paymentMeta': paymentMeta.toMap(),
      'accountOwner': accountOwner,
      'name': name,
      'originalDescription': originalDescription,
      'accountId': accountId,
      'amount': amount,
      'isoCurrencyCode': isoCurrencyCode,
      'unofficialCurrencyCode': unofficialCurrencyCode,
      'date': date,
      'pending': pending,
      'transactionId': transactionId,
      'merchantName': merchantName,
      'checkNumber': checkNumber,
      'paymentChannel': paymentChannel,
      'authorizedDate': authorizedDate,
      'authorizedDatetime': authorizedDatetime,
      'datetime': datetime,
      'transactionCode': transactionCode,
      'personalFinanceCategory': personalFinanceCategory?.toMap(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    final String? pendingTransactionId = map['pending_transaction_id'];
    final String? categoryId = map['category_id'];
    final List<String>? category = List<String>.from(map['category']);
    final PlaidLocation plaidLocation = PlaidLocation.fromMap(map['location']);
    final PaymentMeta paymentMeta = PaymentMeta.fromMap(map['payment_meta']);
    final String? accountOwner = map['account_owner'];
    final String name = map['name'];
    final String? originalDescription = map['original_description'];
    final String accountId = map['account_id'];
    final num amount = map['amount'];
    final String? isoCurrencyCode = map['iso_currency_code'];
    final String? unofficialCurrencyCode = map['unofficial_currency_code'];
    final String date = map['date'];
    final bool pending = map['pending'];
    final String transactionId = map['transaction_id'];
    final String? merchantName = map['merchant_name'];
    final String? checkNumber = map['check_number'];
    final String paymentChannel = map['payment_channel'];
    final String? authorizedDate = map['authorized_date'];
    final String? authorizedDatetime = map['authorized_datetime'];
    final String? datetime = map['datetime'];
    final String? transactionCode = map['transaction_code'];
    final PersonalFinanceCategory? personalFinanceCategory =
        (map['personal_finance_category'] != null)
            ? PersonalFinanceCategory.fromMap(map['personal_finance_category'])
            : null;

    return Transaction(
      pendingTransactionId: pendingTransactionId,
      categoryId: categoryId,
      category: category,
      location: plaidLocation,
      paymentMeta: paymentMeta,
      accountOwner: accountOwner,
      name: name,
      originalDescription: originalDescription,
      accountId: accountId,
      amount: amount,
      isoCurrencyCode: isoCurrencyCode,
      unofficialCurrencyCode: unofficialCurrencyCode,
      date: date,
      pending: pending,
      transactionId: transactionId,
      merchantName: merchantName,
      checkNumber: checkNumber,
      paymentChannel: paymentChannel,
      authorizedDate: authorizedDate,
      authorizedDatetime: authorizedDatetime,
      datetime: datetime,
      transactionCode: transactionCode,
      personalFinanceCategory: personalFinanceCategory,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(pendingTransactionId: $pendingTransactionId, categoryId: $categoryId, category: $category, location: $location, paymentMeta: $paymentMeta, accountOwner: $accountOwner, name: $name, originalDescription: $originalDescription, accountId: $accountId, amount: $amount, isoCurrencyCode: $isoCurrencyCode, unofficialCurrencyCode: $unofficialCurrencyCode, date: $date, pending: $pending, transactionId: $transactionId, merchantName: $merchantName, checkNumber: $checkNumber, paymentChannel: $paymentChannel, authorizedDate: $authorizedDate, authorizedDatetime: $authorizedDatetime, datetime: $datetime, transactionCode: $transactionCode, personalFinanceCategory: $personalFinanceCategory)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.pendingTransactionId == pendingTransactionId &&
        other.categoryId == categoryId &&
        listEquals(other.category, category) &&
        other.location == location &&
        other.paymentMeta == paymentMeta &&
        other.accountOwner == accountOwner &&
        other.name == name &&
        other.originalDescription == originalDescription &&
        other.accountId == accountId &&
        other.amount == amount &&
        other.isoCurrencyCode == isoCurrencyCode &&
        other.unofficialCurrencyCode == unofficialCurrencyCode &&
        other.date == date &&
        other.pending == pending &&
        other.transactionId == transactionId &&
        other.merchantName == merchantName &&
        other.checkNumber == checkNumber &&
        other.paymentChannel == paymentChannel &&
        other.authorizedDate == authorizedDate &&
        other.authorizedDatetime == authorizedDatetime &&
        other.datetime == datetime &&
        other.transactionCode == transactionCode &&
        other.personalFinanceCategory == personalFinanceCategory;
  }

  @override
  int get hashCode {
    return pendingTransactionId.hashCode ^
        categoryId.hashCode ^
        category.hashCode ^
        location.hashCode ^
        paymentMeta.hashCode ^
        accountOwner.hashCode ^
        name.hashCode ^
        originalDescription.hashCode ^
        accountId.hashCode ^
        amount.hashCode ^
        isoCurrencyCode.hashCode ^
        unofficialCurrencyCode.hashCode ^
        date.hashCode ^
        pending.hashCode ^
        transactionId.hashCode ^
        merchantName.hashCode ^
        checkNumber.hashCode ^
        paymentChannel.hashCode ^
        authorizedDate.hashCode ^
        authorizedDatetime.hashCode ^
        datetime.hashCode ^
        transactionCode.hashCode ^
        personalFinanceCategory.hashCode;
  }
}

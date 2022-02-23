import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:cccc/extensions/enum_extension.dart';
import 'package:cccc/extensions/string_extension.dart';
import 'package:cccc/models/enum/payment_channel.dart';
import 'package:cccc/models/transaction_item.dart';

import 'payment_meta.dart';
import 'personal_finance_category.dart';
import 'plaid_location.dart';

/// An array containing transactions from the account. Transactions are
/// returned in reverse chronological order, with the most recent at the
/// beginning of the array. The maximum number of transactions returned is
/// determined by the count parameter.
///
class Transaction {
  const Transaction({
    this.pendingTransactionId,
    this.categoryId,
    this.category,
    this.location,
    this.paymentMeta,
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
    this.isFoodCategory,
    this.transactionItems,
    this.markAsDuplicate,
    this.merchantId,
    this.newMerchantName,
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
  final PlaidLocation? location;

  /// Transaction information specific to inter-bank transfers. If the
  /// transaction was not an inter-bank transfer, all fields will be `null`.
  ///
  /// If the transactions object was returned by a Transactions endpoint such
  /// as `/transactions/get`, the payment_meta key will always appear, but no
  /// data elements are guaranteed. If the transactions object was returned by
  /// an Assets endpoint such as `/asset_report/get/` or
  /// `/asset_report/pdf/get`, this field will only appear in an Asset Report
  /// with Insights.
  final PaymentMeta? paymentMeta;

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
  final DateTime date;

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
  /// Possible values: `online`, `in store`, `other`
  final PaymentChannel paymentChannel;

  /// The date that the transaction was authorized. Dates are returned in an
  /// [ISO 8601]('https://en.wikipedia.org/wiki/ISO_8601') ( `YYYY-MM-DD` ).
  ///
  /// Format: `date`
  final DateTime? authorizedDate;

  /// Date and time when a transaction was authorized in
  /// [ISO 8601]('https://en.wikipedia.org/wiki/ISO_8601')
  /// ( `YYYY-MM-DDTHH:mm:ssZ` ).
  ///
  /// This field is only populated for UK institutions. For institutions in
  /// other countries, will be null.
  ///
  /// Format: `date-time`
  final DateTime? authorizedDatetime;

  /// Date and time when a transaction was posted in
  /// [ISO 8601]('https://en.wikipedia.org/wiki/ISO_8601')
  /// ( `YYYY-MM-DDTHH:mm:ssZ` ).
  ///
  /// This field is only populated for UK institutions. For institutions in
  /// other countries, will be null.
  ///
  /// Format: `date-time`
  final DateTime? datetime;

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

  /// BELOW ARE CUSTOM CREATED FIELDS FOR TRANSCTION DATA

  /// true if the categoryId is in foodCategory
  final bool? isFoodCategory;

  /// List of [TransactionItem] from either receipt scan or other sources
  final List<TransactionItem>? transactionItems;

  /// User specified value of whether the transcation is duplicate or not.
  final bool? markAsDuplicate;

  /// id of the corresponding merchant.
  final String? merchantId;

  /// New Merchant name if the user has modified the [merchantName]. Decided
  /// NOT to modify the original [merchantName] value to make a feature that
  /// let users to reset the data.
  final String? newMerchantName;

  factory Transaction.fromMap(Map<String, dynamic> json) {
    final String? pendingTransactionId = json['pending_transaction_id'];

    final String? categoryId = json['category_id'];
    final List<String>? category =
        (json['category'] as List<dynamic>?)?.map((e) => e as String).toList();

    final PlaidLocation? location = json['location'] == null
        ? null
        : PlaidLocation.fromJson(json['location'] as Map<String, dynamic>);
    final PaymentMeta? paymentMeta = json['payment_meta'] == null
        ? null
        : PaymentMeta.fromJson(json['payment_meta'] as Map<String, dynamic>);

    final String? accountOwner = json['account_owner'];
    final String name = json['name'];
    final String? originalDescription = json['original_description'];
    final String accountId = json['account_id'];

    final num amount = json['amount'];
    final String? isoCurrencyCode = json['iso_currency_code'];
    final String? unofficialCurrencyCode = json['unofficial_currency_code'];
    final DateTime date = (json['date'] as Timestamp).toDate().toUtc();
    final bool pending = json['pending'] as bool;
    final String transactionId = json['transaction_id'];
    final String? merchantName = json['merchant_name'];
    final String? checkNumber = json['check_number'];
    final PaymentChannel paymentChannel =
        (json['payment_channel'] as String).toEnum(PaymentChannel.values);

    final DateTime? authorizedDate = json['authorized_date'] == null
        ? null
        : (json['authorized_date'] as Timestamp).toDate().toUtc();
    final DateTime? authorizedDatetime = json['authorized_datetime'] == null
        ? null
        : (json['authorized_datetime'] as Timestamp).toDate().toUtc();
    final DateTime? datetime = json['datetime'] == null
        ? null
        : (json['datetime'] as Timestamp).toDate().toUtc();
    final String? transactionCode = json['transaction_code'];

    final PersonalFinanceCategory? personalFinanceCategory =
        json['personal_finance_category'] == null
            ? null
            : PersonalFinanceCategory.fromJson(
                json['personal_finance_category'] as Map<String, dynamic>);
    final bool? isFoodCategory = json['is_food_category'];
    final List<TransactionItem>? transactionItems =
        (json['transaction_items'] != null)
            ? (json['transaction_items'] as List)
                .map((e) => TransactionItem.fromMap(e))
                .toList()
            : null;
    final bool? markAsDuplicate = json['mark_as_duplicate'];
    final String? merchantId = json['merchant_id'];
    final String? newMerchantName = json['new_merchant_name'];

    return Transaction(
      location: location,
      paymentMeta: paymentMeta,
      name: name,
      accountId: accountId,
      amount: amount,
      date: date,
      pending: pending,
      transactionId: transactionId,
      paymentChannel: paymentChannel,
      accountOwner: accountOwner,
      authorizedDate: authorizedDate,
      authorizedDatetime: authorizedDatetime,
      datetime: datetime,
      isoCurrencyCode: isoCurrencyCode,
      unofficialCurrencyCode: unofficialCurrencyCode,
      categoryId: categoryId,
      category: category,
      pendingTransactionId: pendingTransactionId,
      merchantName: merchantName,
      checkNumber: checkNumber,
      originalDescription: originalDescription,
      transactionCode: transactionCode,
      personalFinanceCategory: personalFinanceCategory,
      isFoodCategory: isFoodCategory,
      transactionItems: transactionItems,
      markAsDuplicate: markAsDuplicate,
      merchantId: merchantId,
      newMerchantName: newMerchantName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pending_transaction_id': pendingTransactionId,
      'category_id': categoryId,
      'category': category,
      'location': location?.toJson(),
      'payment_meta': paymentMeta?.toJson(),
      'account_owner': accountOwner,
      'name': name,
      'original_description': originalDescription,
      'account_id': accountId,
      'amount': amount,
      'iso_currency_code': isoCurrencyCode,
      'unofficial_currency_code': unofficialCurrencyCode,
      'date': date,
      'pending': pending,
      'transaction_id': transactionId,
      'merchant_name': merchantName,
      'check_number': checkNumber,
      'payment_channel': enumToString(paymentChannel),
      'authorized_date': authorizedDate,
      'authorized_datetime': authorizedDatetime,
      'datetime': datetime,
      'transaction_code': transactionCode,
      'personal_finance_category': personalFinanceCategory?.toJson(),
      'is_food_category': isFoodCategory,
      'transaction_items': transactionItems?.map((e) => e.toMap()).toList(),
      'mark_as_duplicate': markAsDuplicate,
      'merchant_id': merchantId,
      'new_merchant_name': newMerchantName,
    };
  }

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
    DateTime? date,
    bool? pending,
    String? transactionId,
    String? merchantName,
    String? checkNumber,
    PaymentChannel? paymentChannel,
    DateTime? authorizedDate,
    DateTime? authorizedDatetime,
    DateTime? datetime,
    String? transactionCode,
    PersonalFinanceCategory? personalFinanceCategory,
    bool? isFoodCategory,
    List<TransactionItem>? transactionItems,
    bool? markAsDuplicate,
    String? merchantId,
    String? newMerchantName,
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
      isFoodCategory: isFoodCategory ?? this.isFoodCategory,
      transactionItems: transactionItems ?? this.transactionItems,
      markAsDuplicate: markAsDuplicate ?? this.markAsDuplicate,
      merchantId: merchantId ?? this.merchantId,
      newMerchantName: newMerchantName ?? this.newMerchantName,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(pendingTransactionId: $pendingTransactionId, categoryId: $categoryId, category: $category, location: $location, paymentMeta: $paymentMeta, accountOwner: $accountOwner, name: $name, originalDescription: $originalDescription, accountId: $accountId, amount: $amount, isoCurrencyCode: $isoCurrencyCode, unofficialCurrencyCode: $unofficialCurrencyCode, date: $date, pending: $pending, transactionId: $transactionId, merchantName: $merchantName, checkNumber: $checkNumber, paymentChannel: $paymentChannel, authorizedDate: $authorizedDate, authorizedDatetime: $authorizedDatetime, datetime: $datetime, transactionCode: $transactionCode, personalFinanceCategory: $personalFinanceCategory, isFoodCategory: $isFoodCategory, transactionItems: $transactionItems, markAsDuplicate: $markAsDuplicate, merchantId: $merchantId, newMerchantName: $newMerchantName)';
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
        other.personalFinanceCategory == personalFinanceCategory &&
        other.isFoodCategory == isFoodCategory &&
        listEquals(other.transactionItems, transactionItems) &&
        other.markAsDuplicate == markAsDuplicate &&
        other.merchantId == merchantId &&
        other.newMerchantName == newMerchantName;
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
        personalFinanceCategory.hashCode ^
        isFoodCategory.hashCode ^
        transactionItems.hashCode ^
        markAsDuplicate.hashCode ^
        merchantId.hashCode ^
        newMerchantName.hashCode;
  }
}

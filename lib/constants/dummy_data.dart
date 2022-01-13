import 'package:cccc/models/enum/payment_channel.dart';
import 'package:cccc/models/enum/transaction_item_type.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/models/transaction_item.dart';
import 'package:cccc/models/transaction_items.dart';

final transactionDummyData = Transaction(
  name: 'Hoegaarden Orange',
  accountId: 'accountId',
  amount: 23.12,
  date: DateTime.now(),
  pending: false,
  transactionId: 'transactionId',
  paymentChannel: PaymentChannel.inStore,
  accountOwner: 'accountOwner',
  transactionItems: const [
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 12.99,
      type: TransactionItemType.item,
      name: 'Hoegaarden Orange',
      isoCurrencyCode: 'USD',
    ),
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 4.69,
      type: TransactionItemType.item,
      name: 'Thom Eng Muffin',
      isoCurrencyCode: 'USD',
    ),
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 3.99,
      type: TransactionItemType.item,
      name: 'BMG Grade A Eggs 18C',
      isoCurrencyCode: 'USD',
    ),
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 21.97,
      type: TransactionItemType.subtotal,
      name: 'Total Sales',
      isoCurrencyCode: 'USD',
    ),
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 1.15,
      type: TransactionItemType.tax,
      name: 'Sales Tax',
      isoCurrencyCode: 'USD',
    ),
  ],
);

const transactionItemsDummyData = TransactionItems(
  transactionItems: [
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 12.99,
      type: TransactionItemType.item,
      name: 'Hoegaarden Orange',
      isoCurrencyCode: 'USD',
    ),
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 4.69,
      type: TransactionItemType.item,
      name: 'Thom Eng Muffin',
      isoCurrencyCode: 'USD',
    ),
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 3.99,
      type: TransactionItemType.item,
      name: 'BMG Grade A Eggs 18C',
      isoCurrencyCode: 'USD',
    ),
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 21.97,
      type: TransactionItemType.subtotal,
      name: 'Total Sales',
      isoCurrencyCode: 'USD',
    ),
    TransactionItem(
      transactionItemId: 'transactionItemId',
      transactionId: 'transactionId',
      amount: 1.15,
      type: TransactionItemType.tax,
      name: 'Sales Tax',
      isoCurrencyCode: 'USD',
    ),
  ],
);

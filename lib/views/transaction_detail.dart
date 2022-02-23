import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/views/choose_merchant_for_transaction.dart';
import 'package:cccc/widgets/custom_future_builder.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/scan_receipt/scan_receipt_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/models/enum/payment_channel.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/view_models/transaction_detail_screen_model.dart';
import 'package:cccc/widgets/receipt_widget.dart';
import 'package:cccc/widgets/transaction_detail_title.dart';

class TransactionDetail extends ConsumerWidget {
  const TransactionDetail({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  static void show(BuildContext context, Transaction transaction) {
    Navigator.of(context).pushNamed(
      RouteNames.transaction,
      arguments: transaction,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[TransactionDetail][${transaction.transactionId}] building... ');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomStreamBuilder<Transaction?>(
        stream: ref
            .read(databaseProvider)
            .transactionStream(transaction.transactionId),
        errorBuilder: (context, error) {
          logger.e('error: ${error.toString()}');

          return Container();
        },
        loadingWidget: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        builder: (context, transaction) {
          if (transaction == null) {
            logger.d('transaction is null');

            return Container();
          }

          final model = ref.watch(
            transactionDetailScreenModelProvider(transaction),
          );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                stretch: true,
                floating: false,
                pinned: true,
                expandedHeight: 200,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        decoration: Decorations.transactionDetail,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(model.amount, style: model.amountTextStyle),
                            TransactionDetailTitle(name: model.name),
                            if (model.isPending)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Pending',
                                  style: TextStyles.body1Grey,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: model.categories
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Chip(
                                        label: Text(
                                          e,
                                          style: TextStyles.overline,
                                        ),
                                        backgroundColor: Colors.blueGrey,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      if (model.isFood)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: (size.width - 64) / 4,
                                child: Column(
                                  children: const [
                                    Text('0 Kcal', style: TextStyles.body1Bold),
                                    SizedBox(height: 4),
                                    Text('Calories',
                                        style: TextStyles.overlineGrey),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (size.width - 64) / 4,
                                child: Column(
                                  children: const [
                                    Text('0 g', style: TextStyles.body1Bold),
                                    SizedBox(height: 4),
                                    Text('Carbs',
                                        style: TextStyles.overlineGrey),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (size.width - 64) / 4,
                                child: Column(
                                  children: const [
                                    Text('0 g', style: TextStyles.body1Bold),
                                    SizedBox(height: 4),
                                    Text('Proteins',
                                        style: TextStyles.overlineGrey),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (size.width - 64) / 4,
                                child: Column(
                                  children: const [
                                    Text('0 g', style: TextStyles.body1Bold),
                                    SizedBox(height: 4),
                                    Text('Fat', style: TextStyles.overlineGrey),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ExpansionTile(
                        initiallyExpanded: true,
                        collapsedTextColor: Colors.white,
                        textColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        iconColor: Colors.white,
                        childrenPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        leading: const Icon(Icons.receipt),
                        title: const Text(
                          'Items',
                          style: TextStyles.captionNoColor,
                        ),
                        children: [
                          _buildItemsWidget(context),
                        ],
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: const SizedBox(
                          height: 64,
                          width: 56,
                          child: Center(child: Icon(Icons.account_balance)),
                        ),
                        title: const Text(
                          'Account',
                          style: TextStyles.overlineGrey,
                        ),
                        subtitle: CustomFutureBuilder<Account?>(
                          future: model.accountFuture,
                          loadingWidget: const Text(
                            'Loading',
                            style: TextStyles.body2Bold,
                          ),
                          errorBuilder: (context, error) => Text(
                            error.toString(),
                            style: TextStyles.body2Bold,
                          ),
                          builder: (context, account) {
                            return Text(
                              model.accountName(account),
                              style: TextStyles.body2Bold,
                            );
                          },
                        ),
                      ),
                      ListTile(
                        onTap: () => ChooseMerchantForTransaction.show(
                          context,
                          transaction: transaction,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: const SizedBox(
                          height: 64,
                          width: 56,
                          child: Center(
                            child: Icon(Icons.storefront_sharp),
                          ),
                        ),
                        title: const Text(
                          'Merchant',
                          style: TextStyles.overlineGrey,
                        ),
                        subtitle: Text(
                          model.merchantName,
                          style: TextStyles.body2Bold,
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const SizedBox(
                          height: 64,
                          width: 56,
                          child: Center(
                            child: Icon(Icons.today),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        title: const Text(
                          'Date',
                          style: TextStyles.overlineGrey,
                        ),
                        subtitle: Text(
                          model.date,
                          style: TextStyles.body2Bold,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.category),
                        title: const Text(
                          'Category ID',
                          style: TextStyles.caption,
                        ),
                        onTap: () {},
                        trailing: Text(
                          model.categoryId,
                          style: TextStyles.body2Bold,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.dynamic_feed),
                        title: const Text(
                          'Mark As Duplicate',
                          style: TextStyles.caption,
                        ),
                        trailing: Switch(
                          value: false,
                          onChanged: (a) {},
                        ),
                      ),
                      ExpansionTile(
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        textColor: Colors.white,
                        collapsedTextColor: Colors.white,
                        expandedAlignment: Alignment.topLeft,
                        childrenPadding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        leading: const Icon(Icons.description),
                        title: const Text('Description',
                            style: TextStyles.caption),
                        children: [
                          Text(
                            model.originalDescription,
                            style: TextStyles.body2Bold,
                          ),
                        ],
                      ),
                      if (transaction.paymentChannel == PaymentChannel.inStore)
                        ExpansionTile(
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          textColor: Colors.white,
                          collapsedTextColor: Colors.white,
                          leading: const Icon(Icons.map),
                          title: Text(
                            model.paymentChannel,
                            style: TextStyles.caption,
                          ),
                          expandedAlignment: Alignment.centerLeft,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          childrenPadding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          children: [
                            Text(model.lat, style: TextStyles.caption),
                            Text(model.lon, style: TextStyles.caption),
                          ],
                        ),
                      if (model.isFood)
                        const ExpansionTile(
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          textColor: Colors.white,
                          collapsedTextColor: Colors.white,
                          leading: Icon(Icons.dinner_dining),
                          title: Text('Menu', style: TextStyles.caption),
                          children: [],
                        ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemsWidget(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (transaction.transactionItems != null) {
      return ReceiptWidget(
        transactionItems: transaction.transactionItems!,
        color: ThemeColors.primary500.withOpacity(0.24),
      );
    } else {
      return Container(
        height: 160,
        width: size.width - 32,
        decoration: Decorations.white24Radius8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Scan your receipts now to get individual items',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => ScanReceiptBottomSheet(
                    transaction: transaction,
                  ),
                ),
                style: ButtonStyles.text1Primary,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 16),
                    Text('Scan Now'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

import 'package:cccc/providers.dart'
    show
        databaseProvider,
        transactionDetailModelProvider,
        transactionStreamProvider;
import 'package:cccc/routes/go_routes.dart';
import 'package:cccc/widgets/button/button.dart';
import 'package:cccc/widgets/custom_future_builder.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/scan_receipt/scan_receipt_bottom_sheet.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:cccc/widgets/show_adaptive_date_picker.dart';
import 'package:cccc/widgets/transaction_mark_as_duplicate_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseException;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/enum/payment_channel.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/receipt_widget.dart';
import 'package:cccc/widgets/transaction_detail_title.dart';

class TransactionDetailsScreen extends ConsumerStatefulWidget {
  const TransactionDetailsScreen({
    super.key,
    required this.transactionId,
  });

  final String transactionId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionDetailsState();
}

class _TransactionDetailsState extends ConsumerState<TransactionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomStreamBuilder<Transaction?>(
        stream:
            ref.read(databaseProvider).transactionStream(widget.transactionId),
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
            transactionDetailModelProvider(transaction),
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
                                        horizontal: 4,
                                      ),
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
                        onTap: () => ChooseMerchantRoute(
                          transactionId: transaction.transactionId,
                          id: 12,
                        ).push(context),
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
                        onTap: () async {
                          final pickedDate = await showAdaptiveDatePicker(
                            context,
                            initialDate: transaction.date,
                          );

                          if (pickedDate != null) {
                            try {
                              final newTransaction = {
                                'date': pickedDate,
                              };

                              await ref
                                  .read(databaseProvider)
                                  .updateTransaction(
                                    transaction,
                                    newTransaction,
                                  );
                            } on FirebaseException catch (e) {
                              logger.e('Error: ${e.message}');
                              if (!mounted) return;

                              await showAdaptiveDialog(
                                context,
                                title: 'Error',
                                content:
                                    'An error occurred. Message: ${e.message}',
                                defaultActionText: 'OK',
                              );
                            } catch (e) {
                              if (!mounted) return;

                              await showAdaptiveDialog(
                                context,
                                title: 'Error',
                                content:
                                    'An error occurred. Message: ${e.toString()}',
                                defaultActionText: 'OK',
                              );
                            }
                          }
                        },
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
                      TransactionMarkAsDuplicateListTile(
                        transaction: transaction,
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

    final transactionStream = ref.watch(
      transactionStreamProvider(widget.transactionId),
    );

    return transactionStream.when<Widget>(
      data: (transaction) {
        if (transaction == null) return const Placeholder();

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
                  Button.text(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => ScanReceiptBottomSheet(
                        transaction: transaction,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 16),
                        Text('Scan Now'),
                      ],
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () => showModalBottomSheet(
                  //     context: context,
                  //     isScrollControlled: true,
                  //     builder: (context) => ScanReceiptBottomSheet(
                  //       transaction: transaction,
                  //     ),
                  //   ),
                  //   style: ButtonStyles.text(foregroundColor: theme.primaryColor),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: const [
                  //       Icon(Icons.camera_alt),
                  //       SizedBox(width: 16),
                  //       Text('Scan Now'),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        }
      },
      error: (error, stackTrace) => const Placeholder(),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}

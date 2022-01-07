import 'package:cccc/models/enum/payment_channel.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:cccc/theme/theme_colors.dart';
import 'package:cccc/view/scan_receipts_screen.dart';
import 'package:cccc/view_models/transaction_detail_screen_model.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/receipt_widget.dart';
import 'package:flutter/material.dart';

import 'package:cccc/models/plaid/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({
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
    logger.d('[TransactionDetail] building... ');

    final model = ref.watch(transactionDetailScreenModelProvider(transaction));
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            stretch: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.primaryColor,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          model.amount,
                          style: TextStyles.h4W900,
                        ),
                        Text(model.name, style: TextStyles.h6),
                        if (model.isPending)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Pending', style: TextStyles.body1Grey),
                          ),
                        const SizedBox(height: 8),
                        if (model.categories != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: model.categories!
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Chip(
                                      label:
                                          Text(e, style: TextStyles.overline),
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
                  ExpansionTile(
                    initiallyExpanded: true,
                    tilePadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    textColor: theme.primaryColor,
                    collapsedTextColor: Colors.white,
                    leading: const Icon(Icons.receipt),
                    childrenPadding: const EdgeInsets.symmetric(vertical: 16),
                    title: const Text(
                      'Items',
                      style: TextStyles.captionNoColor,
                    ),
                    children: [
                      _buildItemsWidget(context),
                    ],
                  ),
                  CustomStreamBuilder<Account?>(
                    stream: model.acocuntStream,
                    builder: (context, data) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        onTap: () {},
                        leading: const Icon(Icons.account_balance),
                        title: const Text(
                          'Account',
                          style: TextStyles.caption,
                        ),
                        trailing: Text(
                          model.accountName(data),
                          style: TextStyles.body2Bold,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    onTap: () {},
                    leading: const Icon(Icons.storefront_sharp),
                    title: const Text(
                      'Merchant Name',
                      style: TextStyles.caption,
                    ),
                    trailing: Text(
                      model.merchantName,
                      style: TextStyles.body2Bold,
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    onTap: () {},
                    leading: const Icon(Icons.today),
                    title: const Text(
                      'Date',
                      style: TextStyles.caption,
                    ),
                    trailing: Text(
                      model.date,
                      style: TextStyles.body2Bold,
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
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
                  ExpansionTile(
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    textColor: Colors.white,
                    collapsedTextColor: Colors.white,
                    tilePadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 24),
                    leading: const Icon(Icons.description),
                    title: const Text('Description', style: TextStyles.caption),
                    children: [
                      Text(
                        model.originalDescription,
                        style: TextStyles.body2Bold,
                      ),
                    ],
                  ),
                  if (transaction.paymentChannel == PaymentChannel.inStore)
                    ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
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
                      tilePadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      textColor: Colors.white,
                      collapsedTextColor: Colors.white,
                      leading: Icon(Icons.dinner_dining),
                      title: Text('Menu', style: TextStyles.caption),
                      children: [],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsWidget(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (transaction.transactionItems != null) {
      return ReceiptWidget(
        transaction: transaction,
        color: ThemeColors.primary500.withOpacity(0.24),
      );
    } else {
      return Container(
        height: 160,
        width: size.width - 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
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
                onPressed: () => ScanReceiptsScreen.show(context),
                style: CustomButtonTheme.text1Primary,
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

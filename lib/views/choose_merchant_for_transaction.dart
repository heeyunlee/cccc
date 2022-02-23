import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/view_models/choose_merchant_for_transaction_model.dart';
import 'package:cccc/widgets/merchant_list_tile.dart';
import 'package:cccc/widgets/paginated_custom_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseMerchantForTransaction extends ConsumerWidget {
  const ChooseMerchantForTransaction({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  static void show(BuildContext context, {required Transaction transaction}) {
    Navigator.of(context).pushNamed(
      RouteNames.chooseMerchant,
      arguments: transaction,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[ChooseMerchantForTransaction] screen building...');

    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: PaginatedCustomScrollView(
        query: ref.watch(databaseProvider).merchantQuery(),
        listViewPadding: EdgeInsets.fromLTRB(0, 16, 0, padding.bottom + 64),
        headerSliver: SliverAppBar(
          expandedHeight: 184,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.cyanAccent,
                    Colors.black,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Choose Merchant', style: TextStyles.h6W900),
                    const SizedBox(height: 24),
                    const Text(
                      'Originally appeared as',
                      style: TextStyles.overline,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${transaction.merchantName ?? 'Not Found'}" in your account',
                      style: TextStyles.body2,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
        listItemBuilder: (context, merchant) {
          final merch = merchant as Merchant;

          return MerchantListTile(
            transaction: transaction,
            merchant: merch,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(
            chooseMerchantForTransactionModelProvider(transaction),
          );

          return ElevatedButton(
            onPressed: model.isLoading
                ? null
                : () => model.updateTransactionMerchant(context),
            style: ButtonStyles.elevatedFullWidth(context),
            child: const Text('SELECT'),
          );
        },
      ),
    );
  }
}

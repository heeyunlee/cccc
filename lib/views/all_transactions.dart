import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/paginated_custom_scroll_view.dart';
import 'package:cccc/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:cccc/routes/route_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllTransactions extends ConsumerWidget {
  const AllTransactions({
    Key? key,
  }) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.allTransactions);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[Transactions] Screen building...');

    return Scaffold(
      body: PaginatedCustomScrollView(
        headerSliver: const SliverAppBar(
          backgroundColor: Colors.black,
          title: Text('Transactions'),
          pinned: true,
        ),
        query: ref.watch(databaseProvider).transactionsQuery(),
        listViewPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        listItemBuilder: (context, transaction) {
          return TransactionListTile(
            transaction: transaction as Transaction,
          );
        },
      ),
    );
  }
}

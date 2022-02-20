import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/paginated_list_view.dart';
import 'package:cccc/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:cccc/routes/route_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllTransactions extends ConsumerStatefulWidget {
  const AllTransactions({
    Key? key,
  }) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.allTransactions);
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllTransactionsState();
}

class _AllTransactionsState extends ConsumerState<AllTransactions> {
  @override
  Widget build(BuildContext context) {
    logger.d('[Transactions] Screen building...');
    final auth = ref.watch(authProvider);
    final database = ref.watch(databaseProvider(auth.currentUser!.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: PaginatedListView(
        query: database.transactionsQuery(),
        listViewPadding: EdgeInsets.zero,
        listItemBuilder: (context, transaction) {
          return TransactionListTile(
            transaction: transaction as Transaction,
          );
        },
      ),
    );
  }
}

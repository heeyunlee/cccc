import 'package:cccc/services/logger_init.dart';
import 'package:cccc/providers.dart';
import 'package:cccc/widgets/paginated_custom_scroll_view.dart';
import 'package:cccc/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({
    super.key,
  });

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
        query: ref.read(databaseProvider).transactionsQuery(),
        listViewPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        listItemBuilder: (context, transaction) {
          return TransactionListTile(
            transaction: transaction,
          );
        },
      ),
    );
  }
}

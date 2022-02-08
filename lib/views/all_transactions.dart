import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/view_models/all_transactions_model.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/ordered_transactions_list_view.dart';
import 'package:flutter/material.dart';

import 'package:cccc/routes/route_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllTransactions extends ConsumerStatefulWidget {
  const AllTransactions({
    Key? key,
  }) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.transactions);
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
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            title: Text('Transactions'),
          ),
          SliverToBoxAdapter(
            child: CustomStreamBuilder<List<Transaction?>>(
              stream: database.transactionsStream(),
              loadingWidget: Container(),
              // loadingWidget: const CircularProgressIndicator.adaptive(),
              errorBuilder: (context, error) => Container(),
              builder: (context, transactions) {
                if (transactions == null) {
                  return Container();
                }

                return OrderedTransactionsListView(
                  model: ref.watch(allTransactionsModelProvider(transactions)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

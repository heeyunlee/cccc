import 'package:cccc/services/logger_init.dart';
import 'package:cccc/view_models/all_transactions_model.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(allTransactionsModelProvider).getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[Transactions] Screen building...');
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final model = ref.watch(allTransactionsModelProvider);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) => ref
            .read(allTransactionsModelProvider)
            .onScrollNotification(context, n),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.black,
              title: Text('Transactions'),
            ),
            SliverToBoxAdapter(
              child: model.transactions.isEmpty
                  ? SizedBox(
                      width: size.width,
                      height: size.height,
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, padding.bottom),
                          itemCount: model.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = model.transactions[index];

                            return TransactionListTile(
                                transaction: transaction);
                          },
                        ),
                        if (model.isLoading)
                          SizedBox(
                            width: size.width,
                            height: 48,
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

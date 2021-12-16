import 'package:cccc/constants/constants.dart';
import 'package:cccc/model/plaid/transactions_list.dart';
import 'package:cccc/model/enum/transactions_filter.dart';
import 'package:cccc/model/plaid/transaction.dart';
import 'package:cccc/view/recent_transactions_card.dart';
import 'package:cccc/view/recent_transactions_card_header.dart';
import 'package:cccc/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_flexible_space_bar.dart';

final transactionsListProvider =
    StateNotifierProvider<TransactionsList, List<Transaction>>(
  (ref) => TransactionsList(),
);

final transactionsProvider = Provider<List<Transaction>>(
  (ref) => ref.watch(transactionsListProvider),
);

final transactionListFilterProvider = StateProvider(
  (_) => TransactionsFilter.food,
);

final filteredTransactions = Provider<List<Transaction>>(
  (ref) {
    final transactions = ref.watch(transactionsProvider);
    final filter = ref.watch(transactionListFilterProvider);

    switch (filter) {
      case TransactionsFilter.food:
        return transactions
            .where((transaction) =>
                foodCategoryIdList.contains(transaction.categoryId))
            .toList();

      case TransactionsFilter.pending:
        return transactions
            .where((transaction) => transaction.pending)
            .toList();

      case TransactionsFilter.all:
        return transactions;
    }
  },
);

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.5,
            actions: [
              IconButton(
                onPressed: () => SettingsScreen.show(context),
                icon: const Icon(Icons.settings),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: const HomeFlexibleSpaceBar(),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                SizedBox(height: 16),
                RecentTranscationsCardHeader(),
                RecentTransactionsCard(),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

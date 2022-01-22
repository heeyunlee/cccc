import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/styles/decorations.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view_models/account_detail_screen_model.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountDetail extends ConsumerWidget {
  const AccountDetail({
    Key? key,
    required this.account,
  }) : super(key: key);

  final Account account;

  static void show(BuildContext context, Account account) {
    Navigator.of(context).pushNamed(
      RouteNames.account,
      arguments: account,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(accountDetailScreenModelProvider(account));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            stretch: true,
            expandedHeight: 160,
            title: Text(model.name),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: Decorations.accountDetail(context),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(model.mask, style: TextStyles.body1White38Bold),
                          const SizedBox(height: 4),
                          Text(
                            model.currentAmount,
                            style: TextStyles.h4W900,
                          ),
                        ],
                      ),
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
                  const SizedBox(height: 48),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    child: Text(
                      'Transactions',
                      style: TextStyles.h6W900,
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white12,
                    child: CustomStreamBuilder<List<Transaction?>>(
                      stream: model.transactionsStream,
                      // TODO: add loading and error widget
                      loadingWidget: Container(),
                      errorWidget: Container(),
                      builder: (context, data) {
                        if (data != null && data.isNotEmpty) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final transaction = data[index]!;

                              return TransactionListTile(
                                  transaction: transaction);
                            },
                          );
                        } else {
                          return const SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Center(
                              child: Text('No transactions'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

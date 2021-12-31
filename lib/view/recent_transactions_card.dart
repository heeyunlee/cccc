import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/model/plaid/transaction.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom_stream_builder.dart';
import 'transaction_list_tile.dart';
import 'transactions_screen.dart';

class RecentTransactionsCard extends ConsumerWidget {
  const RecentTransactionsCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final uid = auth.currentUser?.uid;
    final database = ref.watch(databaseProvider(uid))!;

    logger.d('''
    UID from auth: ${auth.currentUser?.uid}
    UID from database ${database.uid}
    ''');

    return CustomStreamBuilder<List<Transaction?>>(
      stream: database.transactionsStream(),
      builder: (context, data) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 4,
              ),
              child: Row(
                children: [
                  const Text('Recent Transactions'),
                  const Spacer(),
                  TextButton(
                    onPressed: () => TransactionsScreen.show(
                      context,
                      transactions: data,
                    ),
                    style: CustomButtonTheme.text2,
                    child: const Text('VIEW ALL'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.white12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.zero,
                child: (data.isEmpty)
                    ? const SizedBox(
                        height: 96 * 3,
                        child: Center(
                          child: Text(
                            'No recent transactions',
                            style: TextStyles.body2,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length > 5 ? 5 : data.length,
                        itemBuilder: (context, index) {
                          return TransactionListTile(
                            transaction: data[index]!,
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

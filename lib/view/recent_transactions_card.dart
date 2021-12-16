import 'package:cccc/constants/constants.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:cccc/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentTransactionsCard extends ConsumerWidget {
  const RecentTransactionsCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final transactions = ref.watch(filteredTransactions);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.zero,
        child: transactions.isEmpty
            ? SizedBox(
                height: 96 * 4,
                width: size.width,
                child: const Center(
                  child: Text(
                    'No recent transactions',
                    style: TextStyles.body1,
                  ),
                ),
              )
            : ListView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: transactions.map(
                  (transaction) {
                    final isFood = foodCategoryIdList.contains(
                      transaction.categoryId,
                    );

                    return ListTile(
                      isThreeLine: true,
                      minLeadingWidth: 24,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: SizedBox(
                        width: 32,
                        height: 64,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '🍔',
                            style: isFood
                                ? TextStyles.body1
                                : TextStyles.body1White24,
                          ),
                        ),
                      ),
                      title: Text(
                        transaction.name,
                        style:
                            isFood ? TextStyles.body1 : TextStyles.body1White24,
                        maxLines: 1,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.category.toString(),
                            maxLines: 1,
                            style: isFood
                                ? TextStyles.overlineGrey
                                : TextStyles.overlineWhite12,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction.date.toString(),
                            style: isFood
                                ? TextStyles.captionGreyBold
                                : TextStyles.captionBoldWhite12,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 80,
                        height: 64,
                        child: Center(
                          child: Text(
                            '\$ ${transaction.amount.toString()}',
                            style: isFood
                                ? TextStyles.body2
                                : TextStyles.body2White24,
                          ),
                        ),
                      ),
                      onTap: () {},
                    );
                  },
                ).toList(),
              ),
      ),
    );
  }
}

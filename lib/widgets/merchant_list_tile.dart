import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/providers.dart'
    show chooseMerchantForTransactionModelProvider;
import 'package:cccc/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchantListTile extends ConsumerWidget {
  const MerchantListTile({
    super.key,
    required this.merchant,
    required this.transaction,
  });

  final Merchant merchant;
  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(
      chooseMerchantForTransactionModelProvider(transaction),
    );

    return ListTile(
      selectedTileColor: Colors.white24,
      selectedColor: Colors.white,
      onTap: () => model.setSelectedMerchant(merchant),
      selected: model.selectedMerchantId == merchant.merchantId,
      title: Text(
        merchant.name,
        style: model.selectedMerchantId == merchant.merchantId
            ? TextStyles.captionBold
            : TextStyles.caption,
      ),
    );
  }
}

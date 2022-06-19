import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/providers.dart'
    show chooseMerchantForTransactionModelProvider, databaseProvider;
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/button/button.dart';
import 'package:cccc/widgets/custom_adaptive_progress_indicator.dart';
import 'package:cccc/widgets/merchant_list_tile.dart';
import 'package:cccc/widgets/paginated_custom_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseMerchantForTransaction extends StatefulWidget {
  const ChooseMerchantForTransaction({
    required this.transaction,
    super.key,
  });

  final Transaction transaction;

  @override
  State<ChooseMerchantForTransaction> createState() =>
      _ChooseMerchantForTransactionState();
}

class _ChooseMerchantForTransactionState
    extends State<ChooseMerchantForTransaction> {
  @override
  Widget build(BuildContext context) {
    logger.d('[ChooseMerchantForTransaction] screen building...');

    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          body: PaginatedCustomScrollView(
            query: ref.watch(databaseProvider).merchantQuery(),
            listViewPadding: EdgeInsets.fromLTRB(0, 16, 0, padding.bottom + 64),
            headerSliver: SliverAppBar(
              expandedHeight: 184,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.cyanAccent,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Choose Merchant', style: TextStyles.h6W900),
                        const SizedBox(height: 24),
                        const Text(
                          'Originally appeared as',
                          style: TextStyles.overline,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"${widget.transaction.merchantName ?? 'Not Found'}" in your account',
                          style: TextStyles.body2,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            listItemBuilder: (context, merchant) {
              final merch = merchant as Merchant;

              return MerchantListTile(
                transaction: widget.transaction,
                merchant: merch,
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Consumer(
            builder: (context, ref, child) {
              final model = ref.watch(
                chooseMerchantForTransactionModelProvider(widget.transaction),
              );

              return Button.elevated(
                height: 48,
                width: size.width - 64,
                borderRadius: 16,
                onPressed: model.isLoading
                    ? null
                    : () async {
                        final result = await model.updateTransactionMerchant();

                        if (!mounted) return;

                        if (result) {
                          Navigator.of(context).pop();
                        }
                      },
                child: model.isLoading
                    ? const CustomAdaptiveProgressIndicator(color: Colors.white)
                    : const Text('SELECT'),
              );
            },
          ),
        );
      },
    );
  }
}

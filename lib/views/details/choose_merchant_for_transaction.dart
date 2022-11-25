import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/providers.dart'
    show
        chooseMerchantForTransactionModelProvider,
        databaseProvider,
        transactionStreamProvider;
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/button/button.dart';
import 'package:cccc/widgets/custom_adaptive_progress_indicator.dart';
import 'package:cccc/widgets/merchant_list_tile.dart';
import 'package:cccc/widgets/paginated_custom_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseMerchantForTransactionScreen extends ConsumerStatefulWidget {
  const ChooseMerchantForTransactionScreen({
    required this.transactionId,
    required this.id,
    super.key,
  });

  final String transactionId;
  final int id;

  @override
  ConsumerState<ChooseMerchantForTransactionScreen> createState() =>
      _ChooseMerchantForTransactionScreenState();
}

class _ChooseMerchantForTransactionScreenState
    extends ConsumerState<ChooseMerchantForTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d('[ChooseMerchantForTransaction] screen building...');

    final transactionStream = ref.watch(
      transactionStreamProvider(widget.transactionId),
    );

    return transactionStream.when<Widget>(
      data: (transaction) {
        if (transaction == null) return const Placeholder();

        return _buildScaffold(transaction);
      },
      error: (error, stackTrace) => const Placeholder(),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildScaffold(Transaction transaction) {
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;

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
                      '"${transaction.merchantName ?? 'Not Found'}" in your account',
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
          return MerchantListTile(
            transaction: transaction,
            merchant: merchant,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(
            chooseMerchantForTransactionModelProvider(transaction),
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
  }
}

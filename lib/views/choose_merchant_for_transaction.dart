import 'package:cccc/models/merchant.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/widgets/merchant_list_tile.dart';
import 'package:cccc/widgets/paginated_custom_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseMerchantForTransaction extends ConsumerStatefulWidget {
  const ChooseMerchantForTransaction({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  static void show(BuildContext context, {required Transaction transaction}) {
    Navigator.of(context).pushNamed(
      RouteNames.chooseMerchant,
      arguments: transaction,
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseMerchantForTransactionState();
}

class _ChooseMerchantForTransactionState
    extends ConsumerState<ChooseMerchantForTransaction> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final database = ref.watch(databaseProvider(auth.currentUser!.uid));

    return Scaffold(
      body: PaginatedCustomScrollView(
        query: database.merchantQuery(),
        listViewPadding: EdgeInsets.zero,
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
                      '"${widget.transaction.merchantName ?? 'Not Found'}"',
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

          return MerchantListTile(merchant: merch);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Select'),
      ),
    );
  }
}

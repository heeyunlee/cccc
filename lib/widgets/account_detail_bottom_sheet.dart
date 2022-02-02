import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/views/linked_accounts.dart';
import 'package:cccc/view_models/account_detail_bottom_sheet_model.dart';
import 'package:cccc/widgets/account_connection_state_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bottom_sheet_card.dart';

class AccountDetailBottomSheet extends ConsumerStatefulWidget {
  const AccountDetailBottomSheet({
    Key? key,
    required this.account,
  }) : super(key: key);

  final Account account;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountDetailBottomSheetState();
}

class _AccountDetailBottomSheetState
    extends ConsumerState<AccountDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(
      accountDetailBottomSheetModelProvider(widget.account),
    );

    return BottomSheetCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Row(
                        children: [
                          Text(
                            model.name,
                            style: TextStyles.subtitle2,
                          ),
                          const SizedBox(width: 8),
                          AccountConnectionStateIcon(account: model.account),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'There is an error with connecting the account. Please reauthenticate to fix the issue',
                      style: TextStyles.captionWhite54,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (model.connectionIsError)
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.build, size: 20),
                title: const Text('Fix the account connectivity issue'),
                onTap: () => LinkedAccounts.show(context),
              ),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.edit, size: 20),
              title: const Text('Edit'),
              onTap: () {},
            ),
            const Divider(color: Colors.white12, indent: 8, endIndent: 8),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(
                Icons.link_off,
                size: 20,
                color: Colors.red,
              ),
              title: const Text(
                'Unlink',
                style: TextStyles.body2Red,
              ),
              onTap: () {},
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

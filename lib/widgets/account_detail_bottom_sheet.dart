import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/providers.dart' show accountDetailBottomSheetModelProvider;
import 'package:cccc/styles/styles.dart';
import 'package:cccc/views/linked_accounts.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    model.name,
                    style: TextStyles.subtitle2,
                  ),
                  const SizedBox(height: 8),
                  if (model.connectionIsError)
                    const Text(
                      'There is an error with connecting the account. Please reauthenticate to fix the issue',
                      style: TextStyles.captionWhite54,
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
            onTap: () => LinkedAccounts.show(context),
          ),
        ],
      ),
    );
  }
}

import 'package:cccc/enum/account_connection_state.dart';
import 'package:cccc/routes/go_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/providers.dart' show accountProvider;
import 'package:cccc/styles/styles.dart';

import 'bottom_sheet_card.dart';

class AccountDetailBottomSheet extends ConsumerStatefulWidget {
  const AccountDetailBottomSheet({
    super.key,
    required this.accountId,
  });

  final String accountId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountDetailBottomSheetState();
}

class _AccountDetailBottomSheetState
    extends ConsumerState<AccountDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final asyncAccount = ref.watch(accountProvider(widget.accountId));

    final accountName = asyncAccount.value?.name ?? '';
    final accountConnectionIsError =
        asyncAccount.value?.accountConnectionState ==
            AccountConnectionState.error;

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
                    accountName,
                    style: TextStyles.subtitle2,
                  ),
                  const SizedBox(height: 8),
                  if (accountConnectionIsError)
                    const Text(
                      'There is an error with connecting the account. Please reauthenticate to fix the issue',
                      style: TextStyles.captionWhite54,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (accountConnectionIsError)
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.build, size: 20),
              title: const Text('Fix the account connectivity issue'),
              onTap: () => const LinkedAccountsRoute().push(context),
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
            onTap: () => const LinkedAccountsRoute().push(context),
          ),
        ],
      ),
    );
  }
}

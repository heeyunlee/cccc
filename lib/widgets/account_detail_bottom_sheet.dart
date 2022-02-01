import 'package:cccc/models/enum/account_connection_state.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/styles/styles.dart';
import 'package:cccc/view_models/account_detail_bottom_sheet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = ref.watch(accountDetailBottomSheetModelProvider);

    PlaidLink.onSuccess(model.onSuccessCallback);
    PlaidLink.onEvent(model.onEventCallback);
    PlaidLink.onExit(model.onExitCallback);
  }

  @override
  Widget build(BuildContext context) {
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
                  horizontal: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        widget.account.name,
                        style: TextStyles.subtitle2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'Connection State:  '),
                          TextSpan(
                            text: widget.account.accountConnectionState.name,
                            style: TextStyles.captionNoColor
                                .copyWith(color: Colors.red),
                          )
                        ],
                        style: TextStyles.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.account.accountConnectionState ==
                AccountConnectionState.error)
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.build, size: 20),
                title: const Text('Fix the account connectivity issue'),
                onTap: () => ref
                    .read(accountDetailBottomSheetModelProvider)
                    .openLinkUpdateMode(context, account: widget.account),
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

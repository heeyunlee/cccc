import 'package:cccc/widgets/button/button.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/accounts_institution.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/providers.dart' show institutionCardModelProvider;
import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/account_list_tile_compact.dart';
import 'package:cccc/widgets/custom_adaptive_progress_indicator.dart';
import 'package:cccc/widgets/show_custom_action_sheet.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import 'account_circle_avatar.dart';

class InstitutionCard extends ConsumerStatefulWidget {
  const InstitutionCard({
    super.key,
    required this.accounts,
    required this.institution,
  });

  final List<Account?> accounts;
  final Institution? institution;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InstitutionCardState();
}

class _InstitutionCardState extends ConsumerState<InstitutionCard> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final model = ref.read(institutionCardModelProvider(null));

    PlaidLink.onSuccess.listen(model.onSuccessCallback);
    PlaidLink.onEvent.listen((model.onEventCallback));
    PlaidLink.onExit.listen(model.onExitCallback);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = ref.watch(institutionCardModelProvider(AccountsInstitution(
      accounts: widget.accounts,
      institution: widget.institution,
    )));

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
            leading: InstitutionCircleAvatar(
              institution: widget.institution,
              account: widget.accounts.first!,
            ),
            title: Row(
              children: [
                Text(model.name),
                const SizedBox(width: 16),
              ],
            ),
            trailing: IconButton(
              onPressed: () async {
                final actionSheetResult = await showCustomActionSheet<bool?>(
                  context,
                  actionsCount: 1,
                  actionColors: [Colors.red],
                  actionIconData: [Icons.link_off],
                  actionStrings: ['Unlink'],
                  actionResults: [true],
                );

                if (!mounted) return;

                if (actionSheetResult == true) {
                  final confirmed = await showAdaptiveDialog(
                    context,
                    title: 'Unlink this institution?',
                    content:
                        'All the accounts associated with this institution will be permanently deleted, as well as all the transactions. You will NOT be able to undo this',
                    defaultActionText: 'Delete',
                    isDefaultDestructiveAction: true,
                    cancelAcitionText: 'Cancel',
                  );
                  if (confirmed ?? false) {
                    final status = await model.unlinkAccount();

                    if (!mounted) return;

                    switch (status) {
                      case 404:
                        showAdaptiveDialog(
                          context,
                          title: 'Error',
                          content:
                              'An Error occurred during unlinking the institution. Please try again',
                          defaultActionText: 'OK',
                        );
                    }
                  }
                }
              },
              icon: const Icon(
                Icons.more_vert,
                size: 20,
                color: Colors.white70,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                model.lastSyncedTime,
                style: TextStyles.overlineWhite54,
              ),
            ),
          ),
          if (model.isConnectionError) const SizedBox(height: 24),
          if (model.isConnectionError)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'An Error occurred while connecting the account. Please reauthenticate the account using Plaid',
                style: TextStyles.overlineWhite70,
              ),
            ),
          if (model.isConnectionError)
            Button.outlined(
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              width: size.width - 64,
              height: 40,
              onPressed: model.isLoading
                  ? null
                  : () async {
                      final successful = await model.openLinkUpdateMode();

                      if (!mounted) return;

                      if (!successful) {
                        await showAdaptiveDialog(
                          context,
                          title: 'Error',
                          content: 'An Error Occurred. Please try again.',
                          defaultActionText: 'OK',
                        );
                      }
                    },
              child: model.isLoading
                  ? const CustomAdaptiveProgressIndicator()
                  : const Text('Re-authenticate'),
            ),
          const SizedBox(height: 8),
          const Divider(color: Colors.white12),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.accounts.length,
            itemBuilder: (context, index) => AccountListTileCompact(
              account: widget.accounts[index]!,
              institution: widget.institution,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/accounts_institution.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/providers.dart' show institutionCardModelProvider;
import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/account_list_tile_compact.dart';
import 'package:cccc/widgets/custom_adaptive_progress_indicator.dart';
import 'package:cccc/widgets/show_custom_action_sheet.dart';

import 'account_circle_avatar.dart';
import 'account_connection_state_icon.dart';

class InstitutionCard extends ConsumerStatefulWidget {
  const InstitutionCard({
    Key? key,
    required this.accounts,
    required this.institution,
  }) : super(key: key);

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

    PlaidLink.onSuccess(model.onSuccessCallback);
    PlaidLink.onEvent(model.onEventCallback);
    PlaidLink.onExit(model.onExitCallback);
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
            leading: InstitutionCircleAvatar(institution: widget.institution),
            title: Row(
              children: [
                Text(model.name),
                const SizedBox(width: 16),
                AccountConnectionStateIcon(
                  account: model.firstAccount,
                  size: 24,
                ),
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

                if (actionSheetResult == true) {
                  await model.unlinkAccount(context);
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
            OutlinedButton(
              onPressed: () => model.openLinkUpdateMode(context),
              style: ButtonStyles.outline(
                context,
                width: size.width - 64,
                height: 40,
              ),
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

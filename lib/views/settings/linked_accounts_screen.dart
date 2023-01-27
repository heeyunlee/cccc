import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/providers.dart';
import 'package:cccc/routes/go_routes.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/button/button.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/institution_card.dart';
import 'package:cccc/widgets/show_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LinkedAccountsScreen extends ConsumerWidget {
  const LinkedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[LinkedAccounts] screen building...');

    final model = ref.watch(linkedAccountsModelProvider([]));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Linked Accounts'),
      ),
      body: CustomStreamBuilder<List<Account?>>(
        stream: model.accountsStream,
        loadingWidget: const CircularProgressIndicator.adaptive(),
        errorBuilder: (context, error) => ShowErrorWidget(error: error),
        builder: (context, accounts) {
          if (accounts == null) {
            return const ShowErrorWidget(error: 'No linked Accounts yet...');
          }

          if (accounts.isEmpty) {
            return const Center(
              child: Text('No Linked Accounts yet...'),
            );
          }

          final model = ref.watch(linkedAccountsModelProvider(accounts));

          return SingleChildScrollView(
            child: Column(
              children: [
                ...model.accountsByInstitution.entries
                    .map(
                      (entry) => CustomStreamBuilder<Institution?>(
                        loadingWidget: Container(),
                        errorBuilder: (context, error) {
                          return Container();
                        },
                        stream: model.institutionStream(entry.key),
                        builder: (context, institution) {
                          return InstitutionCard(
                            accounts: entry.value,
                            institution: institution,
                          );
                        },
                      ),
                    )
                    .toList(),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 64)
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Button.elevated(
        height: 48,
        width: 240,
        borderRadius: 24,
        onPressed: () => const AddAccountRoute().push(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add),
            SizedBox(width: 4),
            Text('Add a New Account'),
          ],
        ),
      ),
    );
  }
}

import 'package:cccc/models/enum/account_type.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_stream_builder.dart';
import 'accounts_expansion_tile.dart';
import 'add_account_button.dart';

class AccountsCard extends ConsumerWidget {
  const AccountsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final uid = auth.currentUser!.uid;
    final database = ref.watch(databaseProvider(uid));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Text('Accounts', style: TextStyles.h6),
        ),
        Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.white12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomStreamBuilder<List<Account?>>(
                stream: database.accountsStream(),
                builder: (context, data) {
                  if (data.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.rotate(
                                    angle: -0.1,
                                    child: const Icon(Icons.credit_card),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('+'),
                                  const SizedBox(width: 8),
                                  Transform.rotate(
                                    angle: 0.1,
                                    child: const Icon(Icons.account_balance),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('='),
                                  const SizedBox(width: 8),
                                  const Text('0'),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text('No accounts added yet.'),
                            ],
                          ),
                        ),
                        const Divider(
                          indent: 16,
                          endIndent: 16,
                          color: Colors.white10,
                        ),
                        const SizedBox(height: 8),
                        const AddAccountButton(),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else {
                    final dataByType = <AccountType, List<Account?>>{};

                    for (final account in data) {
                      (dataByType[account!.type] ??= []).add(account);
                    }

                    return Column(
                      children: [
                        ...dataByType.entries.map((entry) {
                          return AccountsExpansionTile(
                            accountType: entry.key,
                            accounts: entry.value,
                          );
                        }).toList(),
                        const Divider(
                          indent: 16,
                          endIndent: 16,
                          color: Colors.white10,
                        ),
                        const SizedBox(height: 8),
                        const AddAccountButton(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

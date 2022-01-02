import 'package:cccc/model/plaid/account.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:cccc/view/accounts_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:cccc/model/enum/account_type.dart';

import 'add_account_button.dart';
import 'custom_stream_builder.dart';

class AccountsCard extends ConsumerWidget {
  const AccountsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final database = ref.watch(databaseProvider(auth.currentUser?.uid))!;

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
                              Transform.rotate(
                                angle: -0.1,
                                child: const Icon(Icons.credit_card),
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
                    final dataByType = data.groupListsBy(
                      (element) => element!.type,
                    );

                    return Column(
                      children: [
                        ...dataByType.entries.map((entry) {
                          return ExpansionTile(
                            leading: Icon(entry.key.icon),
                            initiallyExpanded: true,
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.grey,
                            collapsedTextColor: Colors.white,
                            textColor: Colors.grey,
                            title: Text(
                              entry.key.str,
                            ),
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: entry.value.length,
                                itemBuilder: (context, index) {
                                  final account = entry.value[index];

                                  return AccountsListTile(account: account!);
                                },
                              ),
                            ],
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

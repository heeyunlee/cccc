import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view_models/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_stream_builder.dart';
import 'accounts_expansion_tile.dart';
import 'add_account_button.dart';

class AccountsCard extends ConsumerWidget {
  const AccountsCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final HomeModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                errorBuilder: (context, error) => SizedBox(
                  height: 120,
                  child: Text(
                    'An Error Occurred. Error Code: ${error.toString()}',
                  ),
                ),
                loadingWidget: const SizedBox(
                  height: 120,
                  width: double.maxFinite,
                  child: Center(child: CircularProgressIndicator()),
                ),
                stream: model.accountsStream,
                builder: (context, accounts) {
                  if (accounts == null || accounts.isEmpty) {
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
                    return Column(
                      children: [
                        ...model.accountsByType(accounts).entries.map(
                          (entry) {
                            return AccountsExpansionTile(
                              accountType: entry.key,
                              accounts: entry.value,
                            );
                          },
                        ).toList(),
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

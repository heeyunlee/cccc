import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/models/enum/account_subtype.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/providers.dart' show databaseProvider;
import 'package:cccc/styles/formatter.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/views/details/account_detail.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';

import 'account_circle_avatar.dart';
import 'shimmers.dart';

class AccountListTile extends ConsumerWidget {
  const AccountListTile({
    Key? key,
    required this.account,
  }) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);

    return CustomStreamBuilder<Institution?>(
      stream: database.institutionStream(account.institutionId),
      errorBuilder: (context, error) => const ListTile(
        leading: Icon(Icons.error),
        title: Text('An Error has occurred'),
      ),
      loadingWidget: Shimmers.accountListTile,
      builder: (context, institution) => ListTile(
        onTap: () => AccountDetail.show(
          context,
          account: account,
          institution: institution,
        ),
        leading: InstitutionCircleAvatar(
          institution: institution,
          account: account,
        ),
        title: Text(
          account.officialName ?? account.name,
          style: TextStyles.body2,
          maxLines: 1,
        ),
        subtitle: Text(
          account.subtype?.title ?? account.type.name,
          style: TextStyles.captionGrey,
        ),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Text(
            Formatter.currency(account.balance.current, 'en_US'),
            style: TextStyles.h6W900,
          ),
        ),
      ),
    );
  }
}

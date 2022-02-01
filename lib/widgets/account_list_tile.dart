import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/shimmers.dart';
import 'package:flutter/material.dart';

import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/styles/formatter.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view/account_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'account_circle_avatar.dart';
import 'package:cccc/models/enum/account_subtype.dart';

class AccountListTile extends ConsumerWidget {
  const AccountListTile({
    Key? key,
    required this.account,
  }) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final database = ref.watch(databaseProvider(auth.currentUser!.uid));

    return CustomStreamBuilder<Institution?>(
      stream: database.institutionStream(account.institutionId),
      errorBuilder: (context, error) => const ListTile(
        leading: Icon(Icons.error),
        title: Text('An Error has occurred'),
      ),
      loadingWidget: Shimmers.listTile,
      builder: (context, institution) => ListTile(
        onTap: () => AccountDetail.show(
          context,
          account: account,
          institution: institution,
        ),
        leading: AccountCircleAvatar(
          account: account,
          institution: institution,
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

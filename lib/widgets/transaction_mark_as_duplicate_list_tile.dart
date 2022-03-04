import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/providers.dart' show databaseProvider;
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';

class TransactionMarkAsDuplicateListTile extends ConsumerStatefulWidget {
  const TransactionMarkAsDuplicateListTile({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  ConsumerState<TransactionMarkAsDuplicateListTile> createState() =>
      _TransactionMarkAsDuplicateListTileState();
}

class _TransactionMarkAsDuplicateListTileState
    extends ConsumerState<TransactionMarkAsDuplicateListTile> {
  late bool _markAsDuplicate;

  @override
  void initState() {
    super.initState();
    _markAsDuplicate = widget.transaction.markAsDuplicate ?? false;
  }

  Future<void> changeMarkAsDuplicate(bool value) async {
    try {
      setState(() {
        _markAsDuplicate = value;
      });

      final database = ref.watch(databaseProvider);
      final updatedTransaction = {
        'mark_as_duplicate': _markAsDuplicate,
      };

      await database.updateTransaction(widget.transaction, updatedTransaction);

      logger.d('Updated transaction. markAsDuplicate? $_markAsDuplicate');
    } on FirebaseException catch (e) {
      logger.e('Error: ${e.message}');

      await showAdaptiveDialog(
        context,
        title: 'Error!',
        content: 'An Error occurred. ${e.message}',
        defaultActionText: 'OK',
      );
    } catch (e) {
      await showAdaptiveDialog(
        context,
        title: 'Error!',
        content: 'An Error occurred. ${e.toString()}',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.dynamic_feed),
      title: const Text('Mark As Duplicate', style: TextStyles.caption),
      trailing: Switch.adaptive(
        value: _markAsDuplicate,
        onChanged: (value) async => await changeMarkAsDuplicate(value),
      ),
    );
  }
}

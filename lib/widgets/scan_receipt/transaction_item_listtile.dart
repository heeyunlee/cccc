import 'package:cccc/models/transaction_item.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view_models/scan_receipt_bottom_sheet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class TransactionItemListTile extends ConsumerStatefulWidget {
  const TransactionItemListTile({
    Key? key,
    required this.transactionItem,
    required this.index,
  }) : super(key: key);

  final TransactionItem transactionItem;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionItemListTileState();
}

class _TransactionItemListTileState
    extends ConsumerState<TransactionItemListTile> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return KeyboardActions(
      autoScroll: false,
      disableScroll: true,
      config: KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        nextFocus: false,
        keyboardSeparatorColor: Colors.white10,
        keyboardBarColor: Colors.grey[850],
        actions: [
          KeyboardActionsItem(focusNode: _focusNode),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black12,
              ),
              width: (size.width - 72) / 3 * 2,
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: TextFormField(
                onChanged: (str) => ref
                    .read(scanReceiptBottomSheetModelProvider)
                    .onItemNameChanged(str, widget.index),
                maxLines: 1,
                maxLength: 24,
                style: TextStyles.caption,
                initialValue: widget.transactionItem.name,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: (size.width - 72) / 3,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: TextFormField(
                focusNode: _focusNode,
                maxLines: 1,
                maxLength: 9,
                style: TextStyles.caption,
                textAlign: TextAlign.end,
                onChanged: (str) => ref
                    .read(scanReceiptBottomSheetModelProvider)
                    .onItemAmountChanged(str, widget.index),
                initialValue: widget.transactionItem.amount.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixStyle: TextStyles.caption,
                  prefixText: '\$ ',
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

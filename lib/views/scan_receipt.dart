import 'package:cccc/constants/dummy_data.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/button_styles.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/widgets/receipt_widget.dart';
import 'package:cccc/widgets/scan_receipt/scan_receipt_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ScanReceipt extends StatelessWidget {
  const ScanReceipt({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction? transaction;

  static void show(BuildContext context, {Transaction? transaction}) {
    Navigator.of(context).pushNamed(
      RouteNames.scanReceipts,
      arguments: transaction,
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[ScanReceiptScreen] building... ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Receipts'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.camera_alt, size: 40),
              SizedBox(width: 24),
              Icon(Icons.arrow_forward),
              SizedBox(width: 24),
              Icon(Icons.receipt_long, size: 40),
              SizedBox(width: 24),
              Icon(Icons.arrow_forward),
              SizedBox(width: 24),
              Icon(Icons.list, size: 40),
            ],
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Take a picture of receipt. \nTurn it into list of items. \nDo more detailed expense tracking.',
              style: TextStyles.body2,
              textAlign: TextAlign.center,
            ),
          ),
          ReceiptWidget(
            color: Theme.of(context).primaryColor.withOpacity(0.24),
            transactionItems: transactionDummyData.transactionItems!,
          ),
          const SizedBox(height: 48),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 48,
          width: (size.width - 64) / 2,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyles.outline1,
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16, height: 80),
        SizedBox(
          height: 48,
          width: (size.width - 64) / 2,
          child: OutlinedButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => ScanReceiptBottomSheet(
                transaction: transaction,
              ),
            ),
            style: ButtonStyles.elevated1,
            child: const FittedBox(child: Text('Upload a Receipt')),
          ),
        ),
      ],
    );
  }
}
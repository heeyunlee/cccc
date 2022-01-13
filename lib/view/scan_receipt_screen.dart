import 'package:cccc/constants/dummy_data.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:cccc/widgets/receipt_widget.dart';
import 'package:cccc/view/scan_receipt_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ScanReceiptScreen extends StatelessWidget {
  const ScanReceiptScreen({
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
            transactionItems: transactionItemsDummyData,
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

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black,
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 48,
            width: (size.width - 64) / 2,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: CustomButtonTheme.outline1,
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 48,
            width: (size.width - 64) / 2,
            child: OutlinedButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isDismissible: false,
                isScrollControlled: true,
                builder: (context) => ScanReceiptBottomSheet(
                  transaction: transaction,
                ),
              ),
              style: CustomButtonTheme.elevated1,
              child: const FittedBox(child: Text('Upload a Receipt')),
            ),
          ),
        ],
      ),
    );
  }
}

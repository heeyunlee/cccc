import 'package:cccc/constants/dummy_data.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/button_styles.dart';
import 'package:cccc/widgets/receipt_widget.dart';
import 'package:cccc/widgets/scan_receipt/scan_receipt_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScanReceipt extends StatefulWidget {
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
  State<ScanReceipt> createState() => _ScanReceiptState();
}

class _ScanReceiptState extends State<ScanReceipt>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[ScanReceiptScreen] building... ');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Scan Receipts'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
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
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Take a picture of the receipt'),
                    const SizedBox(height: 48),
                    SvgPicture.asset('assets/svg/receipt.svg', height: 240),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Extract items data'),
                    const SizedBox(height: 24),
                    ReceiptWidget(
                      color: Theme.of(context).primaryColor.withOpacity(0.24),
                      transactionItems: transactionDummyData.transactionItems!,
                    ),
                  ],
                ),
                const Placeholder(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TabPageSelector(
            controller: _tabController,
            indicatorSize: 8,
            selectedColor: Theme.of(context).hintColor,
          ),
          SizedBox(height: 120 + MediaQuery.of(context).padding.bottom),
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
                transaction: widget.transaction,
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

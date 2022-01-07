import 'package:cccc/constants/dummy_data.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:cccc/view_models/scan_receipts_screen_model.dart';
import 'package:cccc/widgets/receipt_widget.dart';
import 'package:cccc/widgets/show_custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanReceiptsScreen extends ConsumerWidget {
  const ScanReceiptsScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.scanReceipts,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[ScanReceiptsScreen] building... ');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Receipts'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.width / 1.5,
            child: Column(
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
              ],
            ),
          ),
          ReceiptWidget(transaction: transactionDummyData),
          // Card(
          //   margin: const EdgeInsets.all(24),
          //   child: Column(
          //     children: [
          //       const SizedBox(height: 8),
          //       ListView.builder(
          //         shrinkWrap: true,
          //         padding: EdgeInsets.zero,
          //         physics: const NeverScrollableScrollPhysics(),
          //         itemCount: transactionDummyData.transactionItems!.length,
          //         itemBuilder: (context, index) {
          //           final item = transactionDummyData.transactionItems![index];

          //           return Padding(
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: 16,
          //               vertical: 8,
          //             ),
          //             child: Column(
          //               children: [
          //                 if (item.type == TransactionItemType.subtotal)
          //                   const Padding(
          //                     padding: EdgeInsets.only(bottom: 12),
          //                     child: Divider(color: Colors.white24),
          //                   ),
          //                 Row(
          //                   children: [
          //                     Text(
          //                       model.itemName(item),
          //                       style: model.itemTextStyle(item),
          //                     ),
          //                     const Spacer(),
          //                     Text(
          //                       model.itemAmount(item),
          //                       style: model.itemTextStyle(item),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //       const SizedBox(height: 8),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 16,
          //           vertical: 8,
          //         ),
          //         child: Row(
          //           children: [
          //             const Text('Total', style: TextStyles.body1Bold),
          //             const Spacer(),
          //             Text(
          //               model.transactionAmount(transactionDummyData),
          //               style: TextStyles.body1Bold,
          //             ),
          //           ],
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //     ],
          //   ),
          // ),
          const Spacer(),
          Row(
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
                  onPressed: () async {
                    await showCustomBottomSheet(
                      context,
                      title: 'Camera',
                      subtitle: 'Open it',
                      firstActionIconData: Icons.camera_alt,
                      firstActionTitle: 'Camera',
                      onFirstActionTap: () => ref
                          .read(scanReceiptsScreenModelProvider)
                          .openCamera(context),
                      secondActionIconData: Icons.photo_library,
                      secondActionTitle: 'Photo Library',
                      onSecondActionTap: () => ref
                          .read(scanReceiptsScreenModelProvider)
                          .openGallery(context),
                      thirdActionIconData: Icons.close,
                      thirdActionTitle: 'Close',
                      onThirdActionTap: () => Navigator.of(context).pop(),
                    );
                  },
                  style: CustomButtonTheme.elevated1,
                  child: const FittedBox(child: Text('Upload a Receipt')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

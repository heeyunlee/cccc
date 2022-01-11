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
import 'package:image_picker/image_picker.dart';

class ScanReceiptsScreen extends ConsumerStatefulWidget {
  const ScanReceiptsScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.scanReceipts,
    );
  }

  @override
  ConsumerState<ScanReceiptsScreen> createState() => _ScanReceiptsScreenState();
}

class _ScanReceiptsScreenState extends ConsumerState<ScanReceiptsScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d('[ScanReceiptsScreen] building... ');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Receipts'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            _buildReceipt(),
            const SizedBox(height: 48),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildReceipt() {
    final model = ref.watch(scanReceiptsScreenModelProvider);

    if (model.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final theme = Theme.of(context);

      return ReceiptWidget(
        color: theme.primaryColor.withOpacity(0.24),
        transactionItems: transactionItemsDummyData,
      );
    }
  }

  Widget _buildFAB() {
    final model = ref.watch(scanReceiptsScreenModelProvider);
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
              onPressed: () async {
                await showCustomBottomSheet(
                  context,
                  title: 'Camera',
                  subtitle: 'Open it',
                  firstActionIconData: Icons.camera_alt,
                  firstActionTitle: 'Camera',
                  onFirstActionTap: () => model.pickAndUploadImage(
                    context,
                    source: ImageSource.camera,
                  ),
                  secondActionIconData: Icons.photo_library,
                  secondActionTitle: 'Photo Library',
                  onSecondActionTap: () => model.pickAndUploadImage(
                    context,
                    source: ImageSource.gallery,
                  ),
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
    );
  }
}

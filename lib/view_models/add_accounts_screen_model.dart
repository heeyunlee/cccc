import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

final addAccountsScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final functions = ref.watch(cloudFunctionsProvider);

    return AddAccountsScreenModel(functions: functions);
  },
);

class AddAccountsScreenModel with ChangeNotifier {
  AddAccountsScreenModel({
    required this.functions,
  });

  final CloudFunctions functions;

  bool isLoading = false;

  Future<void> openLink(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final linkToken = await functions.getLinkToken();

      if (linkToken != null) {
        final linkTokenConfiguration = LinkTokenConfiguration(token: linkToken);

        PlaidLink.open(configuration: linkTokenConfiguration);
      }
    } catch (e) {
      logger.e(e);

      showAdaptiveDialog(
        context,
        title: 'title',
        content: 'content',
        defaultActionText: 'OK',
      );
    }

    isLoading = false;
    notifyListeners();
  }

  void onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    logger.d('''
        Successful Callback: $publicToken, 
        metadata: ${metadata.description()}
        ''');

    final accountIds = metadata.accounts.map((account) => account.id).toList();

    functions.exchangePublicToken(publicToken, accountIds);
  }

  void onEventCallback(String event, LinkEventMetadata metadata) {
    logger.d("onEvent: $event, metadata: ${metadata.description()}");
  }

  void onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    logger.d("onExit metadata: ${metadata.description()}");

    if (error != null) {
      logger.d("onExit error: ${error.description()}");
    }
  }
}

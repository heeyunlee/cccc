import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

final connectPlaidModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final functions = ref.watch(cloudFunctionsProvider);

    return ConnectPlaidModel(functions: functions);
  },
);

class ConnectPlaidModel with ChangeNotifier {
  ConnectPlaidModel({
    required this.functions,
  });

  final CloudFunctions functions;

  bool isLoading = false;

  Future<void> openLink(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await functions.linkTokenCreate();
      final linkToken = response['link_token'] as String?;

      if (linkToken != null) {
        logger.d('Got `link_token`. Will open Link');
        final linkTokenConfiguration = LinkTokenConfiguration(token: linkToken);

        PlaidLink.open(configuration: linkTokenConfiguration);
      } else {
        logger.e('Error Response. $response');
        final errorMessage = response['error_message'];

        showAdaptiveDialog(
          context,
          title: 'Error',
          content:
              'An Error Occurred. An error code is "$errorMessage". Please try again.',
          defaultActionText: 'OK',
        );
      }
    } catch (e) {
      logger.e(e);

      showAdaptiveDialog(
        context,
        title: 'An Error Occurred',
        content: 'Could not open a Plaid Link. Please try again.',
        defaultActionText: 'OK',
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> onSuccessCallback(
    String publicToken,
    LinkSuccessMetadata metadata,
  ) async {
    logger.d('''
        Successful Callback: $publicToken, 
        metadata: ${metadata.description()}
        ''');

    final response = await functions.exchangeAndUpdate(publicToken);
    logger.d('function response: \n$response');
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

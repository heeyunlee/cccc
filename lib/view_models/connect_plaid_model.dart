import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class ConnectPlaidModel with ChangeNotifier {
  ConnectPlaidModel({
    required this.functions,
  });

  final CloudFunctions functions;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> openLink(BuildContext context) async {
    toggleLoading();

    try {
      final response = await functions.createLinkToken();
      final linkToken = response['link_token'] as String?;

      if (linkToken != null) {
        logger.d('Got link_token ($linkToken). Will open Link');
        final linkTokenConfiguration = LinkTokenConfiguration(token: linkToken);

        await PlaidLink.open(configuration: linkTokenConfiguration);
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

    toggleLoading();
  }

  Future<void> onSuccessCallback(
    String publicToken,
    LinkSuccessMetadata metadata,
  ) async {
    logger.d('''
        Successful Callback. 
        public_token: $publicToken,
        institution: ${metadata.institution.id}, 
        metadata: ${metadata.description()},
        ''');
    final institutionId = metadata.institution.id;

    final response = await functions.linkAndConnect(
      publicToken,
      institutionId,
    );
    toggleLoading();

    logger.d('function response: \n$response');
  }

  void onEventCallback(String event, LinkEventMetadata metadata) {
    logger.d("onEvent: $event, metadata: ${metadata.description()}");
  }

  void onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    logger.e("onExit metadata: ${metadata.description()}");

    if (error != null) {
      logger.e("onExit error: ${error.description()}");
    }

    toggleLoading();
  }
}

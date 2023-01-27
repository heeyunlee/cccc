import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/logger_init.dart';
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

  Future<bool> openLink() async {
    toggleLoading();

    try {
      final response = await functions.createLinkToken();
      final linkToken = response['link_token'] as String?;

      if (linkToken != null) {
        logger.d('Got link_token ($linkToken). Will open Link');
        final linkTokenConfiguration = LinkTokenConfiguration(token: linkToken);

        await PlaidLink.open(configuration: linkTokenConfiguration);

        toggleLoading();

        return true;
      } else {
        toggleLoading();

        return false;
        // logger.e('Error Response. $response');
        // final errorMessage = response['error_message'];

        // await showAdaptiveDialog(
        //   context,
        //   title: 'Error',
        //   content:
        //       'An Error Occurred. An error code is "$errorMessage". Please try again.',
        //   defaultActionText: 'OK',
        // );
      }
    } catch (e) {
      toggleLoading();

      logger.e(e);

      return true;

      // showAdaptiveDialog(
      //   context,
      //   title: 'An Error Occurred',
      //   content: 'Could not open a Plaid Link. Please try again.',
      //   defaultActionText: 'OK',
      // );
    }
  }

  Future<void> onSuccessCallback(LinkSuccess success) async {
    final institutionId = success.metadata.institution.id;

    final response = await functions.linkAndConnect(
      success.publicToken,
      institutionId,
    );
    toggleLoading();

    logger.d('function response: \n$response');
  }

  void onEventCallback(LinkEvent event) {
    logger.d(
      "eventName: ${event.name}, metadata: ${event.metadata.description()}",
    );
  }

  void onExitCallback(LinkExit exitEvent) {
    logger.e("onExit metadata: ${exitEvent.metadata}");

    if (exitEvent.error != null) {
      logger.e("onExit error: ${exitEvent.error?.displayMessage}");
    }

    toggleLoading();
  }
}

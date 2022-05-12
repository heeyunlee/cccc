import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import 'package:cccc/extensions/datetime_extension.dart';
import 'package:cccc/enum/account_connection_state.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/logger_init.dart';

class InstitutionCardModel with ChangeNotifier {
  InstitutionCardModel({
    required this.functions,
    required this.institution,
    required this.accounts,
  });

  final CloudFunctions functions;
  final Institution? institution;
  final List<Account?>? accounts;

  String get name => institution?.name ?? 'Name';

  Account? get firstAccount => accounts?.first;

  bool get isConnectionError =>
      AccountConnectionState.error == firstAccount?.accountConnectionState;

  String get lastSyncedTime =>
      'Last synced ${firstAccount?.accountLastSyncedTime?.timeago ?? 'date not available..'}';

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> openLinkUpdateMode() async {
    isLoading = true;

    try {
      final response = await functions.createLinkTokenUpdateMode(
        institution!.institutionId,
      );

      isLoading = false;

      logger.d('createLinkTokenUpdateMode response: $response');
      final linkToken = response['link_token'] as String?;

      if (linkToken != null) {
        logger.d('Got link_token ($linkToken). Will open Link');
        final linkTokenConfiguration = LinkTokenConfiguration(token: linkToken);

        await PlaidLink.open(configuration: linkTokenConfiguration);

        return true;
      } else {
        logger.e('Error Response. $response');

        return false;
      }
    } catch (e) {
      isLoading = false;

      logger.e(e);

      return false;
    }
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

    final response = await functions.linkAndConnectUpdateMode(
      publicToken,
      institutionId,
    );

    logger.d('Response: $response');
  }

  void onEventCallback(String event, LinkEventMetadata metadata) {
    logger.d("onEvent: $event, metadata: ${metadata.description()}");
  }

  void onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    logger.e("onExit metadata: ${metadata.description()}");

    if (error != null) {
      logger.e("onExit error: ${error.description()}");
    }
  }

  Future<int> unlinkAccount() async {
    final institutionId = institution?.institutionId;

    logger.d('Confirmed to unlink. Calling the function now');

    final response = await functions.unlinkAccount(institutionId);

    final status = response.statusCode;

    return status;
  }
}

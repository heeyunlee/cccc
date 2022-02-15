import 'package:cccc/models/enum/account_connection_state.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/accounts_institution.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:cccc/extensions/datetime_extension.dart';

final institutionCardModelProvider = ChangeNotifierProvider.autoDispose
    .family<InstitutionCardModel, AccountsInstitution?>(
  (ref, accountsInstitution) => InstitutionCardModel(
    functions: ref.watch(cloudFunctionsProvider),
    institution: accountsInstitution?.institution,
    accounts: accountsInstitution?.accounts,
  ),
);

class InstitutionCardModel with ChangeNotifier {
  InstitutionCardModel({
    required this.functions,
    required this.institution,
    required this.accounts,
  });

  final CloudFunctions functions;
  final Institution? institution;
  final List<Account?>? accounts;

  bool get isLoading => _isLoading;

  String get name => institution?.name ?? 'Name';

  Account? get firstAccount => accounts?.first;

  bool get isConnectionError =>
      AccountConnectionState.error == firstAccount?.accountConnectionState;

  String get lastSyncedTime =>
      'Last synced ' +
      (firstAccount?.accountLastSyncedTime?.timeago ?? 'date not available..');

  bool _isLoading = false;

  void _toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();

    logger.d('_toggleLoading. Currently isLoading? $_isLoading');
  }

  Future<void> openLinkUpdateMode(BuildContext context) async {
    _toggleLoading();

    try {
      final response = await functions.createLinkTokenUpdateMode(
        institution!.institutionId,
      );
      _toggleLoading();

      logger.d('createLinkTokenUpdateMode response: $response');
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

  Future<void> unlinkAccount(BuildContext context) async {
    final institutionId = institution?.institutionId;

    final confirmUnlinking = await showAdaptiveDialog(
      context,
      title: 'Unlink this institution?',
      content:
          'All the accounts associated with this institution will be permanently deleted, as well as all the transactions. You will NOT be able to undo this',
      defaultActionText: 'Delete',
      isDefaultDestructiveAction: true,
      cancelAcitionText: 'Cancel',
    );

    if (confirmUnlinking ?? false) {
      logger.d('Confirmed to unlink. Calling the function now');

      final response = await functions.unlinkAccount(institutionId);

      final status = response.statusCode;

      switch (status) {
        case 404:
          showAdaptiveDialog(
            context,
            title: 'Error',
            content:
                'An Error occurred during unlinking the institution. Please try again',
            defaultActionText: 'OK',
          );
      }
    }
  }
}

import 'dart:convert';

import 'package:cccc/constants/keys.dart';
import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:plaid_flutter/plaid_flutter.dart';

import 'package:cccc/model/plaid/plaid_transactions_response.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/theme/custom_button_theme.dart';

class ConnectWithPlaidScreen extends ConsumerStatefulWidget {
  const ConnectWithPlaidScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.connectPlaid,
    );
  }

  @override
  _ConnectWithPlaidScreenState createState() => _ConnectWithPlaidScreenState();
}

class _ConnectWithPlaidScreenState
    extends ConsumerState<ConnectWithPlaidScreen> {
  String? _publicToken;
  bool _isLoading = false;

  Future<String> _getLinkToken() async {
    final uri = Uri(
      scheme: 'https',
      host: Keys.cloudFunctionHost,
      path: 'get_link_token',
    );

    final response = await http.post(uri);
    final jsonResponse = jsonDecode(response.body);
    final linkToken = jsonResponse['link_token'];

    return linkToken;
  }

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    _publicToken = publicToken;

    logger.d('''
        Successful Callback: $publicToken, 
        metadata: ${metadata.description()}
        ''');
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    logger.d("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    logger.d("onExit metadata: ${metadata.description()}");

    if (error != null) {
      logger.d("onExit error: ${error.description()}");
    }
  }

  Future<void> _openLink(String linkToken) async {
    try {
      LinkTokenConfiguration linkTokenConfiguration = LinkTokenConfiguration(
        token: linkToken,
      );

      final plaidLinkToken = PlaidLink(
        configuration: linkTokenConfiguration,
        onSuccess: _onSuccessCallback,
        onEvent: _onEventCallback,
        onExit: _onExitCallback,
      );

      plaidLinkToken.open();
    } catch (e) {
      logger.d(e);
    }
  }

  Future<dynamic> _fetchTransactionData() async {
    try {
      final now = DateTime.now();

      final uri = Uri(
        scheme: 'https',
        host: Keys.cloudFunctionHost,
        path: 'fetch_transaction_data',
      );

      final response = await http.post(
        uri,
        body: json.encode({
          'public_token': _publicToken,
          'start_date': DateTime(2021, 11, 1).toString(),
          'end_date': DateTime(now.year, now.month, now.day).toString(),
        }),
      );

      final transactionResponse = PlaidTransactionResponse.fromJson(
        response.body,
      );
      final transactions = transactionResponse.transactions;

      ref.read(transactionsListProvider.notifier).add(transactions);

      logger.d('transaction: $transactions');

      // return transactions;
    } catch (e) {
      // print(e.runtimeType);
      // print(e);

      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Connect with Plaid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
                '''Lorem ipsum dolor sit amet, consectetur sadipiscing elit. Mauris in consectetur enim. Sed blandit lorem tempus lectus tincidunt, eget vestibulum nulla v
                  \niverra. Donec vel magna ac ante dignissim pulvinar. Morbi a auctor metus. 
                  \nNullam purus lacus, pharetra id metus interdum, sollicitudin tempus eros '''),
            OutlinedButton(
              onPressed: () => _fetchTransactionData(),
              child: const Text('Fetch Transaction Data'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 56,
            width: size.width - 48,
            child: OutlinedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                final linkToken = await _getLinkToken();

                _openLink(linkToken);

                setState(() {
                  _isLoading = false;
                });
              },
              style: CustomButtonTheme.outline1,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white,
                    )
                  : const Text('Accept & Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:cccc/model/plaid/plaid_transactions_response.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/utils/logger_init.dart';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:http/http.dart' as http;

import 'private_keys.dart';

class ConnectWithPlaidScreen extends StatefulWidget {
  const ConnectWithPlaidScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.connectPlaid,
    );
  }

  @override
  _ConnectWithPlaidScreenState createState() => _ConnectWithPlaidScreenState();
}

class _ConnectWithPlaidScreenState extends State<ConnectWithPlaidScreen> {
  String? _publicToken;

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    _publicToken = publicToken;

    logger.d('''
        Successful Callback: $publicToken, 
        metadata: ${metadata.description()}
        ''');
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    // print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    // print("onExit metadata: ${metadata.description()}");

    if (error != null) {
      // print("onExit error: ${error.description()}");
    }
  }

  Future<String> _getLinkToken() async {
    final uri = Uri(
      scheme: 'https',
      host: host,
      path: 'get_link_token',
    );

    final response = await http.post(uri);
    final jsonResponse = jsonDecode(response.body);
    final linkToken = jsonResponse['link_token'];

    return linkToken;
  }

  Future<void> _openLink() async {
    try {
      LinkTokenConfiguration linkTokenConfiguration = LinkTokenConfiguration(
        token: await _getLinkToken(),
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
        host: host,
        path: 'fetch_transaction_data',
      );

      final response = await http.post(
        uri,
        body: json.encode({
          'public_token': _publicToken,
          'start_date': DateTime(2021, 12, 1).toString(),
          'end_date': DateTime(now.year, now.month, now.day).toString(),
        }),
      );

      final transaction = PlaidTransactionResponse.fromJson(response.body);

      // print('transaction: $transaction');

      return transaction;
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
        title: const Text('Connect with Plaid'),
      ),
      body: Column(
        children: [],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 56,
            width: size.width - 48,
            child: OutlinedButton(
              onPressed: () {
                _openLink();
              },
              style: CustomButtonTheme.outline1,
              child: const Text('Accept & Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
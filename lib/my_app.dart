import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:http/http.dart' as http;

import 'private_keys.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PlaidLink? _plaidLinkToken;
  String? _accessToken;
  String? _publicToken;
  String? _stringResponse;

  @override
  void initState() {
    super.initState();
  }

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    _publicToken = publicToken;

    setState(() {});

    print("onSuccess: $publicToken, metadata: ${metadata.description()}");
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    print("onExit metadata: ${metadata.description()}");

    if (error != null) {
      print("onExit error: ${error.description()}");
    }
  }

  Future<dynamic> getAccessToken() async {
    // FirebaseFunctions functions = FirebaseFunctions.instance;

    // final callable = functions.httpsCallable(
    //   'get_link_token',
    //   options: HttpsCallableOptions(
    //     timeout: const Duration(seconds: 5),
    //   ),
    // );

    // print('a');
    // try {
    //   final a = await callable.call(<String, dynamic>{
    //     'a': 12,
    //   });
    //   print('b ${a}');
    // } catch (e) {
    //   print('Error is ${e.toString()}');
    // }

    // final result = await callable.call();
    // final a = result.data();

    // return a;

    final uri = Uri(
      scheme: 'https',
      host: host,
      path: 'get_link_token',
    );

    final a = await http.post(uri);
    _accessToken = a.body;

    LinkTokenConfiguration linkTokenConfiguration = LinkTokenConfiguration(
      token: _accessToken ?? '',
    );

    _plaidLinkToken = PlaidLink(
      configuration: linkTokenConfiguration,
      onSuccess: _onSuccessCallback,
      onEvent: _onEventCallback,
      onExit: _onExitCallback,
    );

    setState(() {});
  }

  Future<String> fetchTransactionData() async {
    try {
      final uri = Uri(
        scheme: 'https',
        host: host,
        path: 'fetch_transaction_data',
      );

      final response = await http.post(
        uri,
        body: _publicToken,
      );
      _stringResponse = response.body;

      final List<dynamic> transactions = jsonDecode(_stringResponse!);
      print('type of transactions is ${transactions.runtimeType}');

      final a = transactions.length;

      print('response is $a');

      return response.body;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Container(
          width: double.infinity,
          color: Colors.grey[800],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => getAccessToken(),
                child: Text('Get Access Token: $_accessToken'),
              ),
              ElevatedButton(
                onPressed: () => _plaidLinkToken!.open(),
                child: Text('Public Token: $_publicToken'),
              ),
              ElevatedButton(
                onPressed: () => fetchTransactionData(),
                child: Text('Fetch Transactions:'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:cccc/constants/cloud_functions.dart';
import 'package:cccc/constants/keys.dart';
import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:plaid_flutter/plaid_flutter.dart';

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
  bool _isLoading = false;

  Future<String> _getLinkToken() async {
    final uid = ref.read(authProvider).currentUser!.uid;

    try {
      final uri = Uri(
        scheme: 'https',
        host: Keys.cloudFunctionHost,
        path: CloudFunctions.createLinkToken,
      );

      final response = await http.post(
        uri,
        body: json.encode({
          'uid': uid,
        }),
      );
      logger.d('Response: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      final linkToken = jsonResponse['link_token'];

      return linkToken;
    } catch (e) {
      logger.e('ERROR: $e');

      return '';
    }
  }

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    logger.d('''
        Successful Callback: $publicToken, 
        metadata: ${metadata.description()}
        ''');

    _exchangePublicToken(publicToken);
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

  Future<void> _exchangePublicToken(String _publicToken) async {
    try {
      final uid = ref.read(authProvider).currentUser!.uid;

      final uri = Uri(
        scheme: 'https',
        host: Keys.cloudFunctionHost,
        path: CloudFunctions.exchangePublicToken,
      );

      final response = await http.post(
        uri,
        body: json.encode({
          'uid': uid,
          'public_token': _publicToken,
        }),
      );
      logger.d('Response: ${response.body}');
    } catch (e) {
      logger.d(e);
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
          children: const [
            Text(
                '''Lorem ipsum dolor sit amet, consectetur sadipiscing elit. Mauris in consectetur enim. Sed blandit lorem tempus lectus tincidunt, eget vestibulum nulla v
                  \niverra. Donec vel magna ac ante dignissim pulvinar. Morbi a auctor metus. 
                  \nNullam purus lacus, pharetra id metus interdum, sollicitudin tempus eros '''),
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

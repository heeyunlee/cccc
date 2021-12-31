import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  void initState() {
    super.initState();
    PlaidLink.onSuccess(_onSuccessCallback);
    PlaidLink.onEvent(_onEventCallback);
    PlaidLink.onExit(_onExitCallback);
  }

  bool _isLoading = false;

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    logger.d('''
        Successful Callback: $publicToken, 
        metadata: ${metadata.description()}
        ''');

    final function = ref.read(cloudFunctionsProvider);

    function.exchangePublicToken(context, publicToken: publicToken);
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

      PlaidLink.open(configuration: linkTokenConfiguration);
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

                final function = ref.read(cloudFunctionsProvider);

                final linkToken = await function.getLinkToken(context);

                if (linkToken != null) {
                  _openLink(linkToken);
                }

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

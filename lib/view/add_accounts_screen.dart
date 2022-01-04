import 'package:cccc/view_models/add_accounts_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import 'package:cccc/routes/route_names.dart';
import 'package:cccc/theme/custom_button_theme.dart';

class AddAccountsScreen extends ConsumerStatefulWidget {
  const AddAccountsScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.addAccounts,
    );
  }

  @override
  _AddAccountsScreenState createState() => _AddAccountsScreenState();
}

class _AddAccountsScreenState extends ConsumerState<AddAccountsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = ref.watch(addAccountsScreenModelProvider);

    PlaidLink.onSuccess(model.onSuccessCallback);
    PlaidLink.onEvent(model.onEventCallback);
    PlaidLink.onExit(model.onExitCallback);
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(addAccountsScreenModelProvider);
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
                  \nNullam purus lacus, pharetra id metus interdum, sollicitudin tempus eros ''',
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
              onPressed: () => model.openLink(context),
              style: CustomButtonTheme.outline1,
              child: model.isLoading
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

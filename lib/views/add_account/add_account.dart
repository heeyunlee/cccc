import 'package:cccc/widgets/button/button.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import 'package:cccc/providers.dart' show connectPlaidModelProvider;
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/widgets/custom_adaptive_progress_indicator.dart';

class AddAccount extends ConsumerStatefulWidget {
  const AddAccount({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.addAccounts,
    );
  }

  @override
  ConsumerState<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends ConsumerState<AddAccount> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = ref.watch(connectPlaidModelProvider);

    PlaidLink.onSuccess(model.onSuccessCallback);
    PlaidLink.onEvent(model.onEventCallback);
    PlaidLink.onExit(model.onExitCallback);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = ref.watch(connectPlaidModelProvider);

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
                  \nNullam purus lacus, pharetra id metus interdum, sollicitudin tempus eros 
              ''',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Button.outlined(
        borderRadius: 16,
        width: size.width - 48,
        height: 56,
        onPressed: model.isLoading
            ? null
            : () async {
                final successful = await model.openLink();

                if (!mounted) return;

                if (!successful) {
                  await showAdaptiveDialog(
                    context,
                    title: 'Error',
                    content: 'An Error Occurred. Please try again.',
                    defaultActionText: 'OK',
                  );
                }
              },
        child: model.isLoading
            ? const CustomAdaptiveProgressIndicator(color: Colors.white)
            : const Text('Accept & Continue'),
      ),
    );
  }
}

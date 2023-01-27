import 'package:cccc/widgets/button/button.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/providers.dart' show connectPlaidModelProvider;
import 'package:cccc/widgets/custom_adaptive_progress_indicator.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountState();
}

class _AddAccountState extends ConsumerState<AddAccountScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = ref.watch(connectPlaidModelProvider);

    PlaidLink.onSuccess.listen(model.onSuccessCallback);
    PlaidLink.onEvent.listen((model.onEventCallback));
    PlaidLink.onExit.listen(model.onExitCallback);
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

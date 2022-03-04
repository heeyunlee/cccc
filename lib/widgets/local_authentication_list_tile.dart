import 'package:cccc/providers.dart'
    show
        localAuthenticationServiceProvider,
        privacyAndSecuritySettingsModelProvider;
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalAuthenticationListTile extends ConsumerStatefulWidget {
  const LocalAuthenticationListTile({Key? key})
      : super(key: const ValueKey('LocalAuthenticationListTile'));

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocalAuthenticationListTileState();
}

class _LocalAuthenticationListTileState
    extends ConsumerState<LocalAuthenticationListTile> {
  @override
  void initState() {
    super.initState();
    logger.d('inside LocalAuthenticationListTile setState');

    ref.read(privacyAndSecuritySettingsModelProvider).checkBiometric();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(privacyAndSecuritySettingsModelProvider);
    final localAuth = ref.watch(localAuthenticationServiceProvider);

    if (viewModel.canCheckBiometrics) {
      return ListTile(
        title: const Text('Biometric Authentication'),
        subtitle: Text(
          viewModel.availableBiometric,
          style: TextStyles.captionGreyBold,
        ),
        trailing: Switch.adaptive(
          value: localAuth.useLocalAuth,
          onChanged: (value) => localAuth.useAuthenticationOnChaged(
            context,
            value,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

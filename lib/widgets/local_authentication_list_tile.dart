import 'package:cccc/providers.dart'
    show privacyAndSecuritySettingsModelProvider;
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/custom_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_authentication_switch.dart';

class LocalAuthenticationListTile extends StatelessWidget {
  const LocalAuthenticationListTile({Key? key})
      : super(key: const ValueKey('LocalAuthenticationListTile'));

  @override
  Widget build(BuildContext context) {
    logger.d('[LocalAuthenticationListTile] widget building...');

    return ListTile(
      title: const Text('Biometric Authentication'),
      subtitle: Consumer(
        builder: (context, ref, child) {
          return CustomFutureBuilder<String>(
            future: ref
                .read(privacyAndSecuritySettingsModelProvider)
                .getAvailableBiometrics(),
            builder: (context, availableBiometric) => Text(availableBiometric!),
            errorBuilder: (context, e) => Text(e.toString(), maxLines: 1),
            loadingWidget: const Text('Loading...'),
          );
        },
      ),
      trailing: const LocalAuthenticationSwitch(),
    );
  }
}

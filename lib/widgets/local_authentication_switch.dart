import 'package:cccc/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalAuthenticationSwitch extends ConsumerStatefulWidget {
  const LocalAuthenticationSwitch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocalAuthenticationSwitchState();
}

class _LocalAuthenticationSwitchState
    extends ConsumerState<LocalAuthenticationSwitch> {
  @override
  void initState() {
    super.initState();
    ref.read(privacyAndSecuritySettingsModelProvider).getSwitchValue();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(privacyAndSecuritySettingsModelProvider);

    return Switch.adaptive(
      value: model.switchValue,
      onChanged: (value) => model.switchOnChange(context, value),
    );
  }
}

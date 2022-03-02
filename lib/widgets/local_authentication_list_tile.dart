import 'package:cccc/services/local_authentication_service.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalAuthenticationListTile extends ConsumerStatefulWidget {
  const LocalAuthenticationListTile({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocalAuthenticationListTileState();
}

class _LocalAuthenticationListTileState
    extends ConsumerState<LocalAuthenticationListTile> {
  @override
  void initState() {
    super.initState();
    ref.read(localAuthenticationServiceProvider).checkBiometric();
  }

  @override
  Widget build(BuildContext context) {
    final localAuth = ref.watch(localAuthenticationServiceProvider);

    if (localAuth.canCheckBiometrics) {
      return ListTile(
        title: const Text('Biometric Authentication'),
        subtitle: Text(
          localAuth.availableBiometric,
          style: TextStyles.captionGreyBold,
        ),
        trailing: Switch.adaptive(
          value: localAuth.useLocalAuth,
          onChanged: (value) => ref
              .read(localAuthenticationServiceProvider)
              .useAuthenticationOnChaged(context, value),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

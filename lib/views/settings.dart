import 'package:cccc/constants/image_assets.dart';
import 'package:cccc/providers.dart' show authProvider;
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/views/linked_accounts.dart';
import 'package:cccc/views/privacy_and_security_settings.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.settings,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[Settings] screen building...');

    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => LinkedAccounts.show(context),
            title: const Text('Linked Accounts'),
          ),
          ListTile(
            onTap: () => PrivacyAndSecuritySettings.show(context),
            title: const Text('Privacy & Security'),
          ),
          ListTile(
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: '',
                applicationIcon: ImageAssets.logo,
                // TODO: CHANGE VERSION
                applicationVersion: '0.0.13',
              );
            },
            title: const Text('About'),
          ),
          ListTile(
            onTap: () async {
              final shouldSignOut = await showAdaptiveDialog(
                context,
                title: 'Sign Out',
                content: 'Sign out?',
                defaultActionText: 'Yes',
                cancelAcitionText: 'No',
              );

              if (shouldSignOut ?? false) {
                await auth.signOut();
                Navigator.of(context).pop();
              }
            },
            title: const Text('Sign Out', style: TextStyles.body2Red),
          ),
          const SizedBox(height: 32),
          // TODO: CHANGE VERSION
          const Text('v.0.0.13', style: TextStyles.overlineWhite54),
        ],
      ),
    );
  }
}

import 'package:cccc/extensions/context_extension.dart';
import 'package:cccc/providers.dart' show firebaseAuthProvider;
import 'package:cccc/routes/router.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(firebaseAuthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => context.pushRoute(AppRoutes.linkedAccounts),
            title: const Text('Linked Accounts'),
          ),
          ListTile(
            onTap: () => context.pushRoute(AppRoutes.privacyAndSecurity),
            title: const Text('Privacy & Security'),
          ),
          ListTile(
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: '',
                applicationIcon: Image.asset(
                  'assets/pictures/cccc_logo.png',
                  width: 48,
                  height: 48,
                ),
                // TODO(heeyunlee): Update version
                applicationVersion: '0.0.15',
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
                isDefaultDestructiveAction: true,
                cancelAcitionText: 'No',
              );

              if (shouldSignOut ?? false) {
                await auth.signOut();

                if (!mounted) return;

                Navigator.of(context).pop();
              }
            },
            title: const Text('Sign Out', style: TextStyles.body2Red),
          ),
          const SizedBox(height: 32),
          // TODO(heeyunlee): Update version
          const Text('v.0.0.15', style: TextStyles.overlineWhite54),
        ],
      ),
    );
  }
}

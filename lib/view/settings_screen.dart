import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.settings,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            auth.signOut();

            Navigator.of(context).pop();
          },
          child: const Text('SIGN OUT', style: TextStyles.button2),
        ),
      ),
    );
  }
}

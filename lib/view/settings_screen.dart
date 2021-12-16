import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/auth.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteNames.settings,
    );
  }

  Future<void> _signOut(BuildContext context, FirebaseAuth auth) async {
    await auth.signOut();

    Navigator.of(context).pop();
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
          onPressed: () => _signOut(context, auth),
          child: const Text('SIGN OUT', style: TextStyles.button2),
        ),
      ),
    );
  }
}

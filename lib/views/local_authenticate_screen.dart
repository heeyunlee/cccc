import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/routes/route_names.dart';
import 'package:cccc/services/local_authentication_service.dart';

class LocalAuthenticationScreen extends ConsumerStatefulWidget {
  const LocalAuthenticationScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.authenticate);
  }

  @override
  ConsumerState<LocalAuthenticationScreen> createState() =>
      _LocalAuthenticationScreenState();
}

class _LocalAuthenticationScreenState
    extends ConsumerState<LocalAuthenticationScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(localAuthenticationServiceProvider).authenticate(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: size.width,
              width: size.width,
              child: Center(
                child: Image.asset(
                  'assets/pictures/cccc_logo.png',
                  width: 120,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Unlock',
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              iconSize: 48,
              onPressed: () => ref
                  .read(localAuthenticationServiceProvider)
                  .authenticate(context),
              icon: const Icon(Icons.fingerprint),
            ),
          ],
        ),
      ),
    );
  }
}

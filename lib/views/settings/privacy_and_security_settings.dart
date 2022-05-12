import 'package:flutter/material.dart';

import 'package:cccc/routes/route_names.dart';
import 'package:cccc/widgets/local_authentication_list_tile.dart';

class PrivacyAndSecuritySettings extends StatelessWidget {
  const PrivacyAndSecuritySettings({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.privacyAndSecurity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: Column(
        children: const [
          LocalAuthenticationListTile(),
        ],
      ),
    );
  }
}

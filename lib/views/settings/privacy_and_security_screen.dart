import 'package:flutter/material.dart';

import 'package:cccc/widgets/local_authentication_list_tile.dart';

class PrivacyAndSecurityScreen extends StatelessWidget {
  const PrivacyAndSecurityScreen({super.key});

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

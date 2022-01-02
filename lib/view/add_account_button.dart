import 'package:cccc/theme/custom_button_theme.dart';
import 'package:flutter/material.dart';

import 'connect_with_plaid_screen.dart';

class AddAccountButton extends StatelessWidget {
  const AddAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: TextButton(
        style: CustomButtonTheme.text2,
        onPressed: () => ConnectWithPlaidScreen.show(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add),
            SizedBox(width: 16),
            Text('Add an account'),
          ],
        ),
      ),
    );
  }
}

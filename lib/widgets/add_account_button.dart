import 'package:cccc/styles/button_styles.dart';
import 'package:flutter/material.dart';

import '../views/connect_plaid.dart';

class AddAccountButton extends StatelessWidget {
  const AddAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: TextButton(
        style: ButtonStyles.text2,
        onPressed: () => ConnectPlaid.show(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add),
            SizedBox(width: 16),
            Text('Add More Account'),
          ],
        ),
      ),
    );
  }
}

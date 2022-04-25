import 'package:cccc/views/add_account/add_account.dart';
import 'package:cccc/widgets/button/button.dart';
import 'package:flutter/material.dart';

class AddAccountButton extends StatelessWidget {
  const AddAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Button.text(
      onPressed: () => AddAccount.show(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add),
          SizedBox(width: 16),
          Text('Add More Account'),
        ],
      ),
    );
  }
}

import 'package:cccc/extensions/context_extension.dart';
import 'package:cccc/routes/router.dart';
import 'package:cccc/widgets/button/button.dart';
import 'package:flutter/material.dart';

class AddAccountButton extends StatelessWidget {
  const AddAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Button.text(
      onPressed: () => context.pushRoute(AppRoutes.addAccount),
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

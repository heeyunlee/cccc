import 'package:cccc/styles/text_styles.dart';
import 'package:flutter/material.dart';

class TransactionDetailTitle extends StatelessWidget {
  const TransactionDetailTitle({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    if (name.length > 28) {
      final size = MediaQuery.of(context).size;

      return SizedBox(
        width: size.width - 48,
        child: FittedBox(
          child: Text(name, style: TextStyles.h6),
        ),
      );
    }

    return Text(name, style: TextStyles.h6);
  }
}

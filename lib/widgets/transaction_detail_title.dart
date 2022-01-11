import 'package:cccc/theme/text_styles.dart';
import 'package:flutter/material.dart';

class TransactionDetailTitle extends StatelessWidget {
  const TransactionDetailTitle({
    Key? key,
    required this.name,
  }) : super(key: key);

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

import 'package:flutter/material.dart';

const kInteractiveStates = <MaterialState>{
  MaterialState.pressed,
  MaterialState.hovered,
  MaterialState.focused,
  MaterialState.disabled,
  MaterialState.error,
};

// const kDisabledStates = <MaterialState>{
//   MaterialState.disabled,
//   MaterialState.error,
// };

const kDividerWhite24Indent16 = Divider(
  color: Colors.white24,
  endIndent: 16,
  indent: 16,
);

const Map<String, IconData> kCategoryIdEmojiMap = {
  '22001000': Icons.flight,
  '22016000': Icons.hail,
  '13005000': Icons.restaurant,
  '19046000': Icons.store,
  '13005032': Icons.fastfood,
  '16000000': Icons.account_balance,
  '16001000': Icons.credit_card,
  '21006000': Icons.account_balance,
  '21007000': Icons.account_balance,
  '17018000': Icons.fitness_center,
  '13005043': Icons.local_cafe,
  '21005000': Icons.account_balance,
  '19019000': Icons.shopping_bag,
};

import 'package:cccc/models/merchant.dart';
import 'package:flutter/material.dart';

class MerchantListTile extends StatelessWidget {
  const MerchantListTile({
    Key? key,
    required this.merchant,
  }) : super(key: key);

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      selected: true,
      title: Text(merchant.name),
    );
  }
}

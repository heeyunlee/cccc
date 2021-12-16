import 'package:cached_network_image/cached_network_image.dart';
import 'package:cccc/constants/urls.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:flutter/material.dart';

import 'connect_with_plaid_screen.dart';

class HomeFlexibleSpaceBar extends StatelessWidget {
  const HomeFlexibleSpaceBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FlexibleSpaceBar(
      background: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CachedNetworkImage(
            imageUrl: Urls.homeTabNetworkImage,
            fit: BoxFit.cover,
            height: size.height * 0.66,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Container(
            height: size.height * 0.66,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width - 48,
            height: 48,
            child: OutlinedButton(
              style: CustomButtonTheme.outline1,
              onPressed: () => ConnectWithPlaidScreen.show(context),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 4),
                    Text('Add Account'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

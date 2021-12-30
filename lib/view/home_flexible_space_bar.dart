import 'package:cccc/theme/custom_button_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          Hero(
            tag: 'logo',
            child: SvgPicture.asset(
              'assets/svg/bg.svg',
              height: size.height * 0.6,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: size.height * 0.5,
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
            ],
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

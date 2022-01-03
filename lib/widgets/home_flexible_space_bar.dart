import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeFlexibleSpaceBar extends ConsumerStatefulWidget {
  const HomeFlexibleSpaceBar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeFlexibleSpaceBarState();
}

class _HomeFlexibleSpaceBarState extends ConsumerState<HomeFlexibleSpaceBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.passthrough,
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
                height: 120,
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
        ],
      ),
    );
  }
}
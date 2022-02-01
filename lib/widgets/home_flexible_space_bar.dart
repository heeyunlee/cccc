import 'package:cccc/constants/image_assets.dart';
import 'package:cccc/styles/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          ImageAssets.homeBG,
          Column(
            children: [
              Container(
                height: size.height * 0.1,
                decoration: Decorations.blackToTransGradient,
              ),
              const Spacer(),
              Container(
                height: size.height * 0.5,
                decoration: Decorations.transToBlackGradient,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

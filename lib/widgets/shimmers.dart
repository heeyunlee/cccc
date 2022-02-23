import 'package:cccc/styles/decorations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmers {
  static final accountListTile = Shimmer.fromColors(
    baseColor: Colors.white10,
    highlightColor: Colors.white24,
    child: SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: Decorations.blueGreyCircle,
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 160, height: 16, color: Colors.white),
                const SizedBox(height: 4),
                Container(width: 80, height: 16, color: Colors.white),
              ],
            ),
            const Spacer(),
            Container(width: 64, height: 40, color: Colors.white),
          ],
        ),
      ),
    ),
  );
}

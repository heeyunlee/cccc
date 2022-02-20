import 'package:cccc/styles/decorations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// const _shimmerGradient = LinearGradient(
//   colors: [
//     Color(0xFFEBEBF4),
//     Color(0xFFF4F4F4),
//     Color(0xFFEBEBF4),
//   ],
//   stops: [
//     0.1,
//     0.3,
//     0.4,
//   ],
//   begin: Alignment(-1.0, -0.3),
//   end: Alignment(1.0, 0.3),
//   tileMode: TileMode.clamp,
// );

// class ShimmerLoading extends StatefulWidget {
//   const ShimmerLoading({
//     Key? key,
//     required this.isLoading,
//     required this.child,
//   }) : super(key: key);

//   final bool isLoading;
//   final Widget child;

//   @override
//   _ShimmerLoadingState createState() => _ShimmerLoadingState();
// }

// class _ShimmerLoadingState extends State<ShimmerLoading> {
//   @override
//   Widget build(BuildContext context) {
//     if (!widget.isLoading) {
//       return widget.child;
//     }

//     return ShaderMask(
//       blendMode: BlendMode.srcATop,
//       shaderCallback: (bounds) {
//         return _shimmerGradient.createShader(bounds);
//       },
//       child: widget.child,
//     );
//   }
// }

class Shimmers {
  static final listTile = Shimmer.fromColors(
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
                Container(width: 128, height: 16, color: Colors.white),
                const SizedBox(height: 4),
                Container(width: 64, height: 16, color: Colors.white),
              ],
            ),
            const Spacer(),
            Container(width: 84, height: 40, color: Colors.white),
          ],
        ),
      ),
    ),
  );
}

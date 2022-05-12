// import 'package:cccc/enum/button_type.dart';
// import 'package:flutter/material.dart';

// class NewIconButton extends IconButton {
//   const NewIconButton({
//     super. key,
//     required VoidCallback onPressed,
//     required Widget icon,
//     this.buttonType = ButtonType.material,
//   }) : super(
//           onPressed: onPressed,
//           icon: icon,
//           key: key,
//         );

//   const NewIconButton.adaptive({
//     super. key,
//     required VoidCallback onPressed,
//     required Widget icon,
//     this.buttonType = ButtonType.adaptive,
//   }) : super(onPressed: onPressed, icon: icon, key: key);

//   final ButtonType buttonType;

//   @override
//   Widget build(BuildContext context) {
//     switch (buttonType) {
//       case ButtonType.material:
//         return _buildMaterialIconButton(context);
//       case ButtonType.adaptive:
//         final ThemeData theme = Theme.of(context);

//         switch (theme.platform) {
//           case TargetPlatform.iOS:
//           case TargetPlatform.macOS:
//             return _buildCupertinoIconButton(context);
//           case TargetPlatform.android:
//           case TargetPlatform.fuchsia:
//           case TargetPlatform.linux:
//           case TargetPlatform.windows:
//             return _buildMaterialIconButton(context);
//         }
//     }
//   }

//   Widget _buildMaterialIconButton(BuildContext context) {
//     return IconButton(
//       onPressed: onPressed,
//       icon: icon,
//     );
//   }

//   Widget _buildCupertinoIconButton(BuildContext context) {
//     return IconButton(
//       onPressed: onPressed,
//       icon: icon,
//     );
//   }
// }

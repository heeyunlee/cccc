import 'package:cccc/styles/styles.dart';
import 'package:cccc/widgets/bottom_sheet_card.dart';
import 'package:flutter/material.dart';

Future<T?> showCustomActionSheet<T>(
  BuildContext context, {
  bool showCancelButton = true,
  required int actionsCount,
  required List<String> actionStrings,
  required List<IconData> actionIconData,
  required List<Color> actionColors,
  required List<T> actionResults,
}) async {
  assert(actionStrings.length == actionsCount);
  assert(actionIconData.length == actionsCount);
  assert(actionColors.length == actionsCount);
  assert(actionResults.length == actionsCount);

  final value = await showModalBottomSheet<T>(
    context: context,
    builder: (context) {
      return BottomSheetCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(
              actionsCount,
              (index) => ListTile(
                visualDensity: VisualDensity.compact,
                onTap: () => Navigator.of(context).pop(actionResults[index]),
                leading: Icon(
                  actionIconData[index],
                  size: 20,
                  color: actionColors[index],
                ),
                title: Text(
                  actionStrings[index],
                  style: TextStyles.caption.copyWith(
                    color: actionColors[index],
                  ),
                ),
              ),
            ),
            if (showCancelButton)
              ListTile(
                visualDensity: VisualDensity.compact,
                onTap: () => Navigator.of(context).pop(),
                leading: const Icon(Icons.close, color: Colors.grey, size: 20),
                title: const Text('Close', style: TextStyles.captionGrey),
              ),
          ],
        ),
      );
    },
  );

  return value;
}

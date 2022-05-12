import 'package:flutter/material.dart';

class ShowErrorWidget extends StatelessWidget {
  const ShowErrorWidget({
    super.key,
    required this.error,
  });

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return SizedBox(
      width: double.maxFinite,
      height: media.size.height - media.padding.bottom - media.padding.top,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text('Something went wrong.'),
          const SizedBox(height: 16),
          Text(error.toString()),
        ],
      ),
    );
  }
}

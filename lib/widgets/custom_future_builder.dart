import 'package:flutter/material.dart';

/// Creates a custom [FutureBuilder] widget.
class CustomFutureBuilder<T> extends StatelessWidget {
  const CustomFutureBuilder({
    Key? key,
    required this.future,
    this.initialData,
    required this.builder,
    required this.errorBuilder,
    required this.loadingWidget,
  }) : super(key: key);

  final Future<T> future;

  final T? initialData;

  final Widget Function(BuildContext context, T? data) builder;

  final Widget Function(BuildContext context, Object? error) errorBuilder;

  final Widget loadingWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      key: key,
      future: future,
      initialData: initialData,
      builder: (context, snapshot) {
        if (snapshot.hasError) return errorBuilder(context, snapshot.error);

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return loadingWidget;
          case ConnectionState.done:
          case ConnectionState.none:
          case ConnectionState.active:
            return builder(context, snapshot.data);
        }
      },
    );
  }
}

import 'package:cccc/services/logger_init.dart';
import 'package:flutter/material.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  const CustomStreamBuilder({
    Key? key,
    required this.stream,
    required this.builder,
    this.initialData,
    required this.loadingWidget,
    required this.errorBuilder,
  }) : super(key: key);

  /// [Stream] for the [StreamBuilder]
  final Stream<T> stream;

  /// Initial data for the [StreamBuilder]
  final T? initialData;

  /// A builder function to be used when the `snapshot.hasData` is `true`, and
  /// [ConnectionState] is [ConnectionState.active].
  final Widget Function(BuildContext context, T? data) builder;

  /// A builder function to be used when the `snapshot.hasError` is
  /// `true`
  ///
  final Widget Function(BuildContext context, Object? error) errorBuilder;

  /// A widget to be shown when sapshot connection state is [ConnectionState.none],
  /// [ConnectionState.waiting], or [ConnectionState.done].
  ///
  final Widget loadingWidget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          logger.e('An error on the stream: \n${snapshot.error}');

          return errorBuilder(context, snapshot.error);
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.done:
              return loadingWidget;
            case ConnectionState.active:
              return builder(context, snapshot.data);
          }
        }
      },
    );
  }
}

import 'package:cccc/services/logger_init.dart';
import 'package:flutter/material.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  const CustomStreamBuilder({
    Key? key,
    required this.stream,
    required this.builder,
    required this.errorWidget,
    this.initialData,
    required this.loadingWidget,
  }) : super(key: key);

  final Stream<T> stream;
  final T? initialData;
  final Widget Function(BuildContext context, T? data) builder;

  /// A widget to be shown when snapshot returns error.
  ///
  /// Default is [EmptyContent] widget with errorOccuredMessage and error.
  ///
  final Widget errorWidget;

  /// A widget to be shown when sapshot connection state is [ConnectionState.none],
  /// [ConnectionState.waiting], or [ConnectionState.done].
  ///
  /// Default widget is [CircularProgressIndicator] with color of `Theme.of(context).primaryColor`
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

          return errorWidget;
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

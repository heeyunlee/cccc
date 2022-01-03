import 'package:cccc/services/logger_init.dart';
import 'package:flutter/material.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  const CustomStreamBuilder({
    Key? key,
    required this.stream,
    required this.builder,
    this.errorWidget,
    this.initialData,
    this.loadingWidget,
    this.emptyWidget,
  }) : super(key: key);

  final Stream<T> stream;
  final T? initialData;
  final Widget Function(BuildContext context, T data) builder;

  /// A widget to be shown when snapshot returns error.
  ///
  /// Default is [EmptyContent] widget with errorOccuredMessage and error.
  ///
  final Widget? errorWidget;

  /// A widget to be shown when sapshot connection state is [ConnectionState.none],
  /// [ConnectionState.waiting], or [ConnectionState.done].
  ///
  /// Default widget is [CircularProgressIndicator] with color of `Theme.of(context).primaryColor`
  ///
  final Widget? loadingWidget;

  /// A widget io be shown when `snapshot.data == null`.
  ///
  /// Default is [EmptyContent]
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          logger.e(snapshot.error);

          return errorWidget ??
              const Center(
                child: Text('An Error Occurred'),
              );
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.done:
              return loadingWidget ??
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.primaryColor,
                      ),
                    ),
                  );
            case ConnectionState.active:
              final data = snapshot.data;
              if (data != null) {
                return builder(context, data);
              } else {
                logger.i('Data does NOT exist. Building [emptyWidget]');

                return emptyWidget ?? const Center(child: Text('Empty...'));
              }
          }
        }
      },
    );
  }
}

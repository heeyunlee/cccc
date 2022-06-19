import 'package:cccc/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouterAppRoutes on BuildContext {
  void pushRoute(
    AppRoutes routes, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    return pushNamed(
      routes.name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }
}

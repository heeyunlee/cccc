import 'package:flutter/material.dart';

class AuthStateError extends StatelessWidget {
  const AuthStateError({Key? key, required this.error}) : super(key: key);

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('An Error Occurred... \nError Code: ${error.toString()}'),
      ),
    );
  }
}

import 'package:cccc/services/auth.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/view_models/sign_in_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInViewModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(auth: ref.watch(authProvider)),
);

class SignInViewScreen extends ConsumerWidget {
  const SignInViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(signInViewModelProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed:
                  model.isLoading ? null : () => model.signInAnonymously(),
              style: CustomButtonTheme.text1,
              child: const Text('Sign in Anonymously'),
            ),
          ],
        ),
      ),
    );
  }
}

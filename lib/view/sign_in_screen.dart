import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/view_models/sign_in_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInScreenModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(auth: ref.watch(authProvider)),
);

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(signInScreenModelProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            model.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : OutlinedButton(
                    onPressed: model.isLoading
                        ? null
                        : () => model.signInAnonymously(context, ref),
                    style: CustomButtonTheme.outline1,
                    child: SizedBox(
                      height: 48,
                      width: size.width - 64,
                      child: const Center(
                        child: Text('Sign in Anonymously'),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

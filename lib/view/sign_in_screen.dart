import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/theme/custom_button_theme.dart';
import 'package:cccc/theme/text_styles.dart';
import 'package:cccc/view_models/sign_in_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

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
            SizedBox(
              width: size.width,
              height: size.width,
              child: const Center(
                child: Text('CCCC', style: TextStyles.h4),
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {},
              style: CustomButtonTheme.outline1,
              child: SizedBox(
                height: 48,
                width: size.width - 64,
                child: Stack(
                  children: [
                    Positioned(
                      left: 8,
                      top: 14,
                      child: SvgPicture.asset(
                        'assets/svg/google_logo.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                    const Center(child: Text('Sign in with Google')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('or', style: TextStyles.button2Grey),
            TextButton(
              onPressed: model.isLoading
                  ? null
                  : () => model.signInAnonymously(context, ref),
              style: CustomButtonTheme.text2,
              child: SizedBox(
                height: 48,
                width: size.width - 64,
                child: const Center(
                  child: Text('Sign in Anonymously'),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 48,
            ),
          ],
        ),
      ),
    );
  }
}

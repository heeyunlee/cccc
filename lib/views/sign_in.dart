import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/button_styles.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view_models/sign_in_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SignIn extends ConsumerWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[SignIn] Screen building...');

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
            SizedBox(
              width: size.width,
              height: size.width,
              child: Center(
                child: model.isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Image.asset(
                        'assets/pictures/cccc_logo.png',
                        width: size.width / 3,
                      ),
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: model.isLoading
                  ? null
                  : () => model.signInWithGoogle(context, ref),
              style: ButtonStyles.outline(context, height: 48),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
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
            const SizedBox(height: 16),
            const Text('or', style: TextStyles.overlineGrey),
            TextButton(
              onPressed: model.isLoading
                  ? null
                  : () => model.signInAnonymously(context, ref),
              style: ButtonStyles.text2,
              child: const Text('Sign in Anonymously'),
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

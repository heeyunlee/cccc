import 'package:cccc/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cccc/providers.dart' show signInModelProvider;
import 'package:cccc/styles/text_styles.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(signInModelProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: const ValueKey('SingInScreenScaffold'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            model.isLoading
                ? const CircularProgressIndicator.adaptive()
                : Image.asset(
                    'assets/pictures/cccc_logo.png',
                    width: size.width / 3,
                  ),
            const Spacer(),
            Button.outlined(
              key: const ValueKey('GoogleSignInButton'),
              width: 280,
              height: 48,
              borderRadius: 16,
              onPressed: model.isLoading
                  ? null
                  : () async => await model.signInWithGoogle(context, ref),
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
            Button.text(
              key: const ValueKey('SignInAnonymously'),
              height: 48,
              width: 240,
              textStyle: TextStyles.button2,
              text: 'Sign in Anonymously',
              onPressed: model.isLoading
                  ? null
                  : () async {
                      await model.signInAnonymously(context, ref);
                    },
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

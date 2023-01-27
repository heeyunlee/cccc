// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cccc/services/firebase_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cccc/main.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();

  // used to generate a unique application name for each test
  var testCount = 0;

  void mockSignInAnonymously() {
    final mockAuthService = FirebaseAuthService();
    when(mockAuthService.signInAnonymously()).thenAnswer((_) async {
      final auth = MockFirebaseAuth();

      final userCredential = await auth.signInAnonymously();
      return userCredential.user;
    });
  }

  void mockAuthStateChanged() {
    final mockAuthService = FirebaseAuthService();

    when(mockAuthService.authStateChanges).thenAnswer((_) {
      final auth = MockFirebaseAuth();

      return auth.onAuthStateChanged;
    });
  }

  setUpAll(() async {
    await Firebase.initializeApp(
      name: '$testCount',
      options: const FirebaseOptions(
        apiKey: '',
        appId: '',
        messagingSenderId: '',
        projectId: '',
      ),
    );
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    mockSignInAnonymously();
    mockAuthStateChanged();

    await tester.pumpWidget(const MyAppWithProviderScope());
    await tester.pumpAndSettle();

    expect(find.text('Sign in Anonymously'), findsOneWidget);
    await tester.tap(find.text('Sign in Anonymously'));
  });
}

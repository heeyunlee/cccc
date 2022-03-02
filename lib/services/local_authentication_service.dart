import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cccc/extensions/string_extension.dart';

final localAuthenticationServiceProvider = ChangeNotifierProvider(
  (ref) => LocalAuthenticationService(),
);

/// A class that deals with [LocalAuthentication] and its related functions
class LocalAuthenticationService with ChangeNotifier {
  /// user's preference on whether to use local authentication or not.
  /// Defaults to `false`
  bool get useLocalAuth => _useLocalAuth;

  /// boolean value on whether the device is authenticated or not.
  /// Defaults to `false`
  bool get isAuthenticated => _isAuthenticated;

  /// boolean value on whether the device is able to check Biometrics.
  /// Defaults to `false`
  bool get canCheckBiometrics => _canCheckBiometrics;

  /// String value of the first element of the `availableBioMetrics` list
  String get availableBiometric => _availableBiometric;

  bool _useLocalAuth = false;
  bool _isAuthenticated = false;
  bool _canCheckBiometrics = false;
  String _availableBiometric = '';
  final LocalAuthentication _auth = LocalAuthentication();

  /// A function that gets user's pre-defined preference on whether he/she wants
  /// to use the [LocalAuthentication] by using [SharedPreferences] library.
  ///
  /// Using [SharedPreferences], the function gets `useLocalAuth` value, and
  /// when it's `null`, it sets the value to `false`
  Future<void> getLocalAuthPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? _useLocalAuthPrefs = prefs.getBool('useLocalAuth');

    if (_useLocalAuthPrefs == null) {
      await prefs.setBool('useLocalAuth', false);
    }
    _useLocalAuth = _useLocalAuthPrefs ?? false;
    notifyListeners();

    logger.d('''
        useLocalAuth in sharedpref: $_useLocalAuthPrefs,
        _useLocalAuth in Service: $_useLocalAuth,
        _isauthenticated in service: $_isAuthenticated,
    ''');
  }

  /// A function that checks if the user's device supports Biometric
  /// Authentication. It updates the value `_canCheckBiometrics` and
  /// `_availableBiometric` based on the result.
  void checkBiometric() async {
    final canCheckBiometrics = await _auth.canCheckBiometrics;

    if (canCheckBiometrics) {
      final availableBioMetrics = await _auth.getAvailableBiometrics();

      _canCheckBiometrics = canCheckBiometrics;
      _availableBiometric = availableBioMetrics.first.name.title;
      notifyListeners();
    }
  }

  /// A function that calls [LocalAuthentication] library's authenticate function.
  /// It also handlues Exceptions
  Future<bool> authenticate(BuildContext context) async {
    logger.d('authenticate function called');

    try {
      const iosStrings = IOSAuthMessages(
        cancelButton: 'cancel',
        goToSettingsButton: 'settings',
        goToSettingsDescription: 'Please set up your Touch ID.',
        lockOut: 'Please reenable your Touch ID',
      );

      final _authenticatedResult = await _auth.authenticate(
        localizedReason: 'Use either your biometric to authenticate',
        stickyAuth: true,
        iOSAuthStrings: iosStrings,
        useErrorDialogs: true,
        sensitiveTransaction: false,
      );

      if (_authenticatedResult) {
        _isAuthenticated = true;
        notifyListeners();

        return _authenticatedResult;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      logger.e('Exception found in using local authentication: ${e.message}');

      final dialog = await showAdaptiveDialog(
        context,
        title: 'An Error Occurred',
        content: e.message ?? 'An error occurred',
        defaultActionText: 'OK',
      );
      return dialog ?? false;
    }
  }

  /// A function that changes user's preferences on using [LocalAuthentication]
  /// based on user's input with [Switch] widget. It also updates the
  /// `useLocalAuth` value in [SharedPreferences] instance.
  ///
  /// If the user opt to use the local authentication, it immediately calls
  /// [authenticate] function.
  void useAuthenticationOnChaged(BuildContext context, bool value) async {
    _useLocalAuth = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    if (value) {
      final authSuccessful = await authenticate(context);

      if (authSuccessful) {
        await prefs.setBool('useLocalAuth', true);
        _isAuthenticated = true;
      } else {
        _useLocalAuth = false;
        _isAuthenticated = false;
      }
    } else {
      await prefs.setBool('useLocalAuth', value);
      _isAuthenticated = false;
    }
    notifyListeners();
  }
}

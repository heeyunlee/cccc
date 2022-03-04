import 'package:cccc/services/logger_init.dart';
import 'package:cccc/services/shared_preference_service.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that deals with [LocalAuthentication] and its related functions
class LocalAuthenticationService with ChangeNotifier {
  LocalAuthenticationService({required this.sharedPref});

  final SharedPreferencesService sharedPref;
  final LocalAuthentication _auth = LocalAuthentication();

  /// user's preference on whether to use local authentication or not.
  /// Defaults to `false`
  bool get useLocalAuth => _useLocalAuth;

  /// boolean value on whether the device is authenticated or not.
  /// Defaults to `false`
  bool get isAuthenticated => _isAuthenticated;

  late bool _useLocalAuth;
  bool _isAuthenticated = false;

  void setUseLocalAuth(bool? value) {
    _useLocalAuth = value ?? false;
    notifyListeners();
  }

  void setIsAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  /// A function that calls [LocalAuthentication] library's authenticate function.
  /// It also handlues Exceptions
  Future<bool> authenticate(BuildContext context) async {
    final widgetKey = context.widget.key;
    logger.d('authenticate function called. Widget key: $widgetKey');

    try {
      const iosStrings = IOSAuthMessages(
        cancelButton: 'cancel',
        goToSettingsButton: 'settings',
        goToSettingsDescription: 'Please set up your Touch ID.',
        lockOut: 'Please reenable your Touch ID',
      );

      final _authenticatedResult = await _auth.authenticate(
        localizedReason: 'Use either your biometric to authenticate',
        iOSAuthStrings: iosStrings,
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
        title: 'Error',
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

    if (value) {
      logger.d('value is true. Call Local auth and authenticate');

      final authSuccessful = await authenticate(context);

      if (authSuccessful) {
        final updated = await sharedPref.update<bool>(
          'useLocalAuth',
          value,
        );

        logger.d('authenticated? $authSuccessful. Updated to $value: $updated');
      } else {
        _useLocalAuth = false;
        _isAuthenticated = false;
        final updated = await sharedPref.update<bool>(
          'useLocalAuth',
          false,
        );

        logger.d('authenticated? $authSuccessful. Updated to $value: $updated');
      }
    } else {
      _useLocalAuth = value;
      final updated = await sharedPref.update<bool>(
        'useLocalAuth',
        false,
      );
      logger.d('updated user auth pref? $updated');
    }
    notifyListeners();
  }
}

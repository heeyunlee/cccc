import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cccc/extensions/string_extension.dart';

import 'package:cccc/services/shared_preference_service.dart';

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

  /// A function that gets `useLocalAuth` value from [SharedPreferencesService].
  Future<bool> getUseLocalAuth() async {
    final useLocalAuth = await sharedPref.get<bool?>('useLocalAuth', bool);
    _useLocalAuth = useLocalAuth ?? false;

    return _useLocalAuth;
  }

  /// A function that gets the capitalized `string` of first availableBiometrics.
  ///
  /// If `availableBiometrics` is empty, it returns `Passcode`
  Future<String> getAvailableBiometric() async {
    final availableBiometrics = await _auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      return availableBiometrics.first.name.title;
    } else {
      return 'Passcode';
    }
  }

  /// A function that sets [_isAuthenticated] value and calls `notifyListeners()`
  void setIsAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  /// A function that calls [LocalAuthentication] library's authenticate function.
  /// It also handlues Exceptions
  Future<Map<String, dynamic>> authenticate() async {
    final result = <String, dynamic>{};

    try {
      const iosStrings = IOSAuthMessages(
        cancelButton: 'cancel',
        goToSettingsButton: 'settings',
        goToSettingsDescription: 'Please set up your Touch ID.',
        lockOut: 'Please reenable your Touch ID',
      );

      final authenticated = await _auth.authenticate(
        localizedReason: 'Enable Local Auth',
        iOSAuthStrings: iosStrings,
      );

      result['authenticated'] = authenticated;
      result['message'] = 'authentication successful';
    } on PlatformException catch (e) {
      /// Handle exception here
      result['authenticated'] = false;
      result['message'] = e.message;
    }

    return result;
  }

  /// A function call combines [authenticate] and [setIsAuthenticated] functions
  /// to call authenticate then update [_isAuthenticated] value
  Future<void> authenticateAndUpdate() async {
    final authResult = await authenticate();
    final authenticated = authResult['authenticated'];

    if (authenticated) {
      setIsAuthenticated(true);
    }
  }
}

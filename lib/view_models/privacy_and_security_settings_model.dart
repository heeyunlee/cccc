import 'package:cccc/services/local_authentication_service.dart';
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/services/shared_preference_service.dart';
import 'package:flutter/material.dart';

class PrivacyAndSecuritySettingsModel with ChangeNotifier {
  PrivacyAndSecuritySettingsModel({required this.localAuth});

  final LocalAuthenticationService localAuth;
  final SharedPreferencesService _prefs = SharedPreferencesService();

  /// String value of the first element of the `availableBioMetrics` list
  String get availableBiometric => _availableBiometric;

  /// [bool] value for [Switch] widget in `LocalAuthenticationListTile` class
  bool get switchValue => _switchValue;

  late String _availableBiometric;
  bool _switchValue = false;

  /// A function that gets the [String] value of availableBiometric from
  /// [LocalAuthenticationService] class.
  Future<String> getAvailableBiometrics() async {
    logger.d('getAvailableBiometrics future called');

    return await localAuth.getAvailableBiometric();
  }

  /// A function that gets [bool] value for [_switchValue] from [LocalAuthenticationService]
  /// class.
  Future<void> getSwitchValue() async {
    final switchValue = await localAuth.getUseLocalAuth();
    _switchValue = switchValue;
    logger.d('_switchValue after future $_switchValue');
  }

  Future<void> switchOnChange(BuildContext context, bool value) async {
    logger.d('switch value: $value');

    _switchValue = value;
    notifyListeners();

    if (value) {
      final authResult = await localAuth.authenticate();
      final authSuccessful = authResult['authenticated'] as bool;

      if (authSuccessful) {
        await _prefs.update('useLocalAuth', value);
      } else {
        _switchValue = false;
        notifyListeners();
      }
    } else {
      final updated = await _prefs.update('useLocalAuth', value);

      if (updated) {
        localAuth.setIsAuthenticated(false);
      }
    }
  }
}

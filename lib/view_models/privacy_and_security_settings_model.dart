import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cccc/extensions/string_extension.dart';

class PrivacyAndSecuritySettingsModel with ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();

  /// String value of the first element of the `availableBioMetrics` list
  String get availableBiometric => _availableBiometric;

  /// boolean value on whether the device is able to check Biometrics.
  /// Defaults to `false`
  bool get canCheckBiometrics => _canCheckBiometrics;

  late String _availableBiometric;
  late bool _canCheckBiometrics;

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
}

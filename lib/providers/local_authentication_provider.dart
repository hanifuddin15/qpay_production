import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/widgets/pin_input_dialog.dart';

class LocalAuthenticationProvider extends ChangeNotifier {
  LocalAuthenticationProvider(this.onError) : super() {
    init();
  }

  BuildContext _uiContext;
  final onError;
  bool _canCheckBiometrics = false;
  bool _isShowingDialog = false;
  bool _isAuthenticated = false;
  bool _isBiometricEnrolled = true;
  List<BiometricType> _availableBiometrics = <BiometricType>[];
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool get isAuthenticated => _isAuthenticated;

  Future<void> _hasBiometricHardware() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    _canCheckBiometrics = isAvailable;
  }

  Future<void> _loadListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
      _availableBiometrics = listOfBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<bool> _authenticateUserBiometrics() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Confirm Biometric to continue ',options: const AuthenticationOptions(
        useErrorDialogs: false,stickyAuth: true,biometricOnly: true));

    } on PlatformException catch (e) {
      if (e.code == Constant.fingerprintNotEnrolled) {
        _isBiometricEnrolled = false;
      }
      print(e);
    }
    return isAuthenticated;
  }

  void unAuthenticated() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void authenticateUser(BuildContext context) async {
    this._uiContext = context;
    await _hasBiometricHardware();
    await _loadListOfBiometricTypes();
    if (_isBiometricCheckAvailable() && _isBiometricEnrolled) {
      await _useBiometricAuthentication();

    } else {

//      await _usePinAuthentication();
    }
  }

  Future _useBiometricAuthentication() async {
    _isAuthenticated = await _authenticateUserBiometrics();
    if (_isBiometricEnrolled) {
      notifyListeners();
    } else {
//      await _usePinAuthentication();
    }
  }

  bool _isBiometricCheckAvailable() {
    return _canCheckBiometrics &&
        _availableBiometrics != null &&
        _availableBiometrics.length > 0;
  }

  //pin auth

  void init() async {}

}

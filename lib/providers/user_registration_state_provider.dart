import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/net/contract/user_register_dto.dart';
import 'package:qpay/providers/value_update_provider.dart';
import 'package:qpay/utils/device_utils.dart';

import 'nid_parse_information_state_provider.dart';
import 'nid_update_status_provider.dart';

class UserRegistrationStateProvider extends ChangeNotifier
    implements ValueHolderUpdateProvider {
  static final UserRegistrationStateProvider _singleton =
      UserRegistrationStateProvider._internal();

  factory UserRegistrationStateProvider() => _singleton;

  UserRegistrationStateProvider._internal();

  NidUpdateDataHolder _nidUpdateDataHolder;
  NidParseInformationProvider _nidParseInformationProvider;

  String _mobileNumber;
  String _vCode;
  String _email;
  String _vCodeEmail;
  String _password;
  String _deviceId;
  String _deviceName;
  String _deviceModel;
  String _profileImage;
  String _operator;

  void setPhoneData(String phone, String operator, String vCode) {
    _mobileNumber = phone;
    _vCode = vCode;
    _operator = operator;
    notifyListeners();
  }

  void setEmailAddress(String emailAddress,String vCodeEmail){
    _email = emailAddress;
    _vCodeEmail = vCodeEmail;
    notifyListeners();
  }
  void setProfileImagePath(String profileImage) {
    _profileImage = profileImage;
    notifyListeners();
  }


  String get profileImage => _profileImage;

  UserRegisterDto getUserData() {
      return UserRegisterDto(_mobileNumber,_operator,_vCode,_email,_vCodeEmail,_password,_deviceId,_deviceName,_deviceModel,_profileImage);
  }

  bool hasAllValidProperties() {
    return _mobileNumber != null &&
        _mobileNumber.isNotEmpty &&
        _operator != null &&
        _operator.isNotEmpty &&
        _vCode != null &&
        _vCode.isNotEmpty &&
        _email != null &&
        _email.isNotEmpty &&
        _vCodeEmail != null &&
        _vCodeEmail.isNotEmpty &&
        _password != null &&
        _password.isNotEmpty &&
        _profileImage != null &&
        _profileImage.isNotEmpty &&
        _nidUpdateDataHolder != null &&
        _nidParseInformationProvider != null;
  }

  void setPersonalCredentialData(String password, String confirmPassword) {
    _password = password;
  }

  void setDeviceData(Map<String, dynamic> deviceData) {
    _deviceId = (SpUtil.getString(Constant.fcmDeviceId)!=''||SpUtil.getString(Constant.fcmDeviceId)!=null)?SpUtil.getString(Constant.fcmDeviceId):deviceData[DeviceInfoProvider.deviceId];;
    _deviceName = deviceData[DeviceInfoProvider.deviceName];
    _deviceModel = deviceData[DeviceInfoProvider.deviceVersion];
  }

  @override
  void clear() {
    _mobileNumber = null;
    _operator = null;
    _vCode = null;
    _email = null;
    _vCodeEmail = null;
    _password = null;
    _profileImage = null;
    _deviceId = null;
    _deviceModel = null;
    _deviceName = null;
  }

  void clearVerificationData() {
    _password = null;
  }
}

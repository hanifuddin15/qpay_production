
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';



import 'package:flutter/foundation.dart';
import 'package:qpay/common/appconstants.dart';
/// https://medium.com/gskinner-team/flutter-simplify-platform-screen-size-detection-4cb6fc4f7ed1
class Device {
  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);
  static bool get isMobile => isAndroid || isIOS;
  static bool get isWeb => kIsWeb;

  static bool get isWindows => Platform.isWindows;
  static bool get isLinux => Platform.isLinux;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isFuchsia => Platform.isFuchsia;
  static bool get isIOS => Platform.isIOS;
}


class DeviceInfoProvider extends ChangeNotifier {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  static const String deviceName = 'deviceName';
  static const String deviceId = 'deviceId';
  static const String deviceVersion = 'version';

  DeviceInfoProvider() : super() {
    init();
  }

  Map<String, dynamic> get deviceData => _deviceData;

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    if (SpUtil.getString('deviceName').isNotEmpty && SpUtil.getString('deviceVersion').isNotEmpty) {
      return <String, dynamic>{
        deviceName: SpUtil.getString(deviceName),
        deviceId: SpUtil.getString(deviceId),
        deviceVersion: SpUtil.getString(deviceVersion),
      };
    }

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    _deviceData = deviceData;
    SpUtil.putString(deviceName, _deviceData[deviceName]);
    SpUtil.putString(deviceId, _deviceData[deviceId]);
    SpUtil.putString(deviceVersion, _deviceData[deviceVersion]);

    _deviceData = deviceData;
    if (_deviceData != null && _deviceData.isNotEmpty) notifyListeners();
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      deviceName: build.model,
      deviceId: build.androidId,
      deviceVersion: build.version.toString(),
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      deviceName: data.name,
      deviceId: data.identifierForVendor,
      deviceVersion: data.systemVersion,
    };
  }

  void init() async {
    await initPlatformState();
  }
}
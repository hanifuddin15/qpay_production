
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/utils/toast.dart';

class DoubleTapBackExitApp extends StatefulWidget {

  const DoubleTapBackExitApp({
    Key key,
    @required this.child,
    this.duration = const Duration(milliseconds: 2500),
  }): super(key: key);

  final Widget child;
  final Duration duration;

  @override
  _DoubleTapBackExitAppState createState() => _DoubleTapBackExitAppState();
}

class _DoubleTapBackExitAppState extends State<DoubleTapBackExitApp> {

  DateTime  _lastTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExit,
      child: widget.child,
    );
  }

  Future<bool> _isExit() async {
    if (_lastTime == null || DateTime.now().difference(_lastTime) > widget.duration) {
      _lastTime = DateTime.now();
      Toast.show(AppLocalizations.of(context).doubleTapToExit);
      return Future.value(false);
    }
    Toast.cancelToast();
    await SystemNavigator.pop();
    return Future.value(true);
  }
}


import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'application.dart';
import 'routers.dart';

class NavigatorUtils {

  static Future<void> push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    unfocus();
    Future.delayed(Duration(milliseconds: 500),()
    {
      Application.router.navigateTo(context, path, replace: replace,
          clearStack: clearStack,
          transition: TransitionType.inFromRight);
    });
  }

  static void popUntil(BuildContext context,String path){
    unfocus();
    Future.delayed(Duration(milliseconds: 500),(){
      Application.router.navigateTo(context, path, replace: true, clearStack: true,rootNavigator: true, transition: TransitionType.inFromRight);
    });

  }

  static Future pushAwait(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    unfocus();
    var future = Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.inFromRight);

    return future;
  }

  static void pushResult(BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    unfocus();
    Application.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: TransitionType.inFromRight).then((Object result) {
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((dynamic error) {
      print('$error');
    });
  }

  static void goBack(BuildContext context) {
    unfocus();
    Navigator.pop(context);
  }

  static void goBackWithParams(BuildContext context, Object result) {
    unfocus();
    Navigator.pop<Object>(context, result);
  }

  static void goWebViewPage(BuildContext context, String title, String url) {
    push(context, '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  }

  static void unfocus() {
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    FocusManager.instance.primaryFocus?.unfocus();
  }
}


import 'package:oktoast/oktoast.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/resources.dart';

class Toast {

  static void show(String msg, {int duration = 4000}) {
    if (msg == null) {
      return;
    }
    showToast(
      msg,
      textStyle: TextStyles.textSize16,
      backgroundColor: Colours.app_main,
      duration: Duration(milliseconds: duration),
      dismissOtherToast: true
    );
  }

  static void cancelToast() {
    dismissAllToast();
  }
}

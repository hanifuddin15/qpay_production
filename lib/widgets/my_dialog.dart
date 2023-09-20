import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/widgets/my_button.dart';

class MyDialog extends StatelessWidget {
  const MyDialog(
      {Key key,
      this.title,
        @required this.actionText,
      this.cancelText,
      this.onPressed,
      this.onBackPressed,
      this.hiddenTitle = false,
      @required this.child})
      : super(key: key);

  final String title;
  final String actionText;
  final String cancelText;
  final VoidCallback onPressed;
  final VoidCallback onBackPressed;
  final Widget child;
  final bool hiddenTitle;

  @override
  Widget build(BuildContext context) {
    var dialogTitle = Visibility(
      visible: !hiddenTitle,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Text(
          hiddenTitle ? '' : title,
          style: TextStyles.textBold14,
        ),
      ),
    );
    var bottomButton = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        Visibility(
          visible: cancelText != ""?true:false,
          child: MyDialogButton(
            text: cancelText,
            isPositive: false,
            onPressed: onBackPressed,
          ),
        ),
        Visibility(
          visible: cancelText != "" && actionText != ""?true:false,
          child: Gaps.hGap32,
        ),
        Visibility(
          visible: actionText != ""?true:false,
          child: MyDialogButton(
            text: actionText,
            onPressed: onPressed,
          ),
        ),
    ],
    );

    var body = Material(
      borderRadius: BorderRadius.circular(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Gaps.vGap16,
          dialogTitle,
          Flexible(child: child),
          Gaps.vGap50,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: cancelText != "" && actionText != ""? bottomButton : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bottomButton
              ],
            ),
          ),
        ],
      ),
    );

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInCubic,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: body,
          ),
        ),
      ),
    );
  }
}

/*class _DialogButton extends StatelessWidget {
  const _DialogButton({
    Key key,
    this.text,
    this.textColor,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48.0,
        child: FlatButton(
          child: Text(
            text.toUpperCase(),
            style: TextStyles.textBold12,
          ),
          textColor: textColor,
          onPressed: onPressed,
        ),
      ),
    );
  }
}*/


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/widgets/load_image.dart';

class TransactionDetailDialog extends StatelessWidget{
  const TransactionDetailDialog(
      {Key key,
        @required this.actionText,
        this.cancelText,
        this.onPressed,
        this.onBackPressed,
        @required this.child,
      @required this.statusImage})
      : super(key: key);

  final String actionText;
  final String cancelText;
  final VoidCallback onPressed;
  final VoidCallback onBackPressed;
  final Widget child;
  final String statusImage;

  @override
  Widget build(BuildContext context) {
    var bottomButton = Row(
      children: <Widget>[
        _DialogButton(
          text: actionText,
          textColor: Colors.white,
          onPressed: onPressed,
        ),
      ],
    );
    var body = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height*.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  Material(child: child),
                ],
              )),
              Material(child: Align(alignment:Alignment.bottomCenter, child: bottomButton,))
            ],
          ),
        ),
        Positioned(
          top: Consts.padding+5,
          left: Consts.padding,
          right: Consts.padding,
          child: LoadAssetImage(
            statusImage,
            width:Consts.avatarRadius ,
            height: Consts.avatarRadius,
          ),
        ),
      ],
    );

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
            width: MediaQuery.of(context).size.width*.85,
            height:  MediaQuery.of(context).size.height*.85,
            child: body,
          ), 
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
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
        height: 38.0,
        child: ElevatedButton(
          child: Text(
            text.toUpperCase(),
            style: TextStyles.textBold12,
          ),
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
              foreground: Paint()..color = textColor,
            )),
            backgroundColor: MaterialStateProperty.all<Color>(Colours.app_main)
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class Consts {
  Consts._();
  static const double padding = 12.0;
  static const double avatarRadius = 50.0;
}
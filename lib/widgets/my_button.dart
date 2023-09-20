import 'package:flutter/material.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/utils/theme_utils.dart';
import 'package:qpay/widgets/custome_elevation.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key key,
    this.text = '',
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeUtils.isDark(context);
    return CustomElevation(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states){
              if(states.contains(MaterialState.disabled))
                return TextStyle(foreground: Paint()..color = Colours.text,fontSize: 18);
              return TextStyle(foreground: Paint()..color = Colors.white,fontSize: 18);
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states){
                if(states.contains(MaterialState.disabled))
                  return Colours.button_disabled;
                return Colours.app_main;
              },
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
        ),
        child: Container(
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(text,),
        ),
      ),
    );
  }
}

class MyDialogButton extends StatelessWidget {
  const MyDialogButton({
    Key key,
    this.text = '',
    this.isPositive = true,
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final bool isPositive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          foreground: Paint()..color = Colors.white,
        )),
        backgroundColor: MaterialStateProperty.all<Color>(isPositive ? Colours.app_main : Colours.text,),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)))
      ),
      child: Container(
        height: 24,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: Dimens.font_sp18),
        ),
      ),
    );
  }
}

class MyCheckButton extends StatelessWidget {
  const MyCheckButton({
    Key key,
    this.text = '',
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomSecondElevation(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
            foreground: Paint()..color= Colors.white,
          ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colours.app_main),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),)
        ),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontSize: Dimens.font_sp18),
          ),
        ),
      ),
    );
  }
}

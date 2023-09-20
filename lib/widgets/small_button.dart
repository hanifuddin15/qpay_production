
import 'package:flutter/material.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/utils/theme_utils.dart';
import 'package:qpay/widgets/custome_elevation.dart';

class SmallButton extends StatelessWidget {

  const SmallButton({
    Key key,
    this.text = '',
    @required this.onPressed,
  }): super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeUtils.isDark(context);
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          splashFactory: InkRipple.splashFactory,
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
            foreground: Paint()..color= Colors.white,
          )) ,
          backgroundColor: MaterialStateProperty.all<Color>(Colours.emiButtonBg,),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)))
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(fontSize: Dimens.font_sp16,fontFamily: 'SF'),),
        ),
      );
  }
}

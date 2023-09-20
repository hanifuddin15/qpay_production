import 'package:flutter/material.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/utils/theme_utils.dart';

class MyIconButton extends StatelessWidget {
  MyIconButton({
    Key key,
    this.text = '',
    @required this.onPressed,
    @required this.icon,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          text,
          style: TextStyle(fontSize: Dimens.font_sp14),
        ));
  }
}

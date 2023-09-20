import 'package:flutter/material.dart';
import 'package:qpay/res/resources.dart';

class LineWidget extends StatelessWidget {
 final Color color;

  LineWidget({this.color = Colours.dark_bg_gray});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.6,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Gaps.line,
      color: color,
    );
  }
}

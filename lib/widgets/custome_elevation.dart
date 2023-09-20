import 'package:flutter/material.dart';
import 'package:qpay/res/colors.dart';

class CustomElevation extends StatelessWidget {
  final Widget child;

  CustomElevation({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colours.app_main.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: this.child,
    );
  }
}

class CustomSecondElevation extends StatelessWidget {
  final Widget child;

  CustomSecondElevation({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colours.app_main.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
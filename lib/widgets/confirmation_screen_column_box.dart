import 'package:flutter/cupertino.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/styles.dart';

class ConfirmScreenAmountColumnBox extends StatelessWidget {
  final String title;
  final String amount;

  ConfirmScreenAmountColumnBox(this.title, this.amount);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
              fontSize: Dimens.font_sp12
          ),
        ),
        Gaps.vGap10,
        Text(
          amount,
          style: TextStyles.textBold14,
        ),
      ],
    );
  }
}

class ConfirmScreenLargeAmountColumnBox extends StatelessWidget {
  final String title;
  final String amount;

  ConfirmScreenLargeAmountColumnBox(this.title, this.amount);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: Dimens.font_sp16
          ),
        ),
        Gaps.vGap10,
        Text(
          amount,
          style: TextStyles.textBold24,
        ),
      ],
    );
  }
}
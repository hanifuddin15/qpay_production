import 'package:flutter/material.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/res/resources.dart';

Widget AccountElementWidget(
    {@required BuildContext context,
      @required String cardIssuedBankImage,
      @required String cardNumber,
      @required String cardHolder,
      @required String cardType,}) {
  return Container(
    height: 72,
    width: MediaQuery.of(context).size.width,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Container(
            width:60,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: NetworkImage(cardIssuedBankImage),
                fit: BoxFit.scaleDown,
                scale: 1,
              ),
            ),
          ),
        ),
        Gaps.hGap24,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$cardHolder'??'Holder Name', style: TextStyle(fontSize: Dimens.font_sp16,color: Colours.text),),
            Gaps.vGap4,
            Text('$cardNumber'??'Number',style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.text_gray),),
            Gaps.vGap4,
            Text('$cardType'??'Type',style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.text_gray),),
          ],
        ),
      ],
    ),
  );
}
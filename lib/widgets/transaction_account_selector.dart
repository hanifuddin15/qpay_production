import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/widgets/line_widget.dart';

class TransactionAccountSelector extends StatelessWidget {
  final String _action;
  final LinkedAccountViewModel _account;
  final bool isEnabled;
  final bool isSource;

  TransactionAccountSelector(this._action, this._account, {this.isEnabled = true,this.isSource =false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      leading:SizedBox(
        width: MediaQuery.of(context).size.width*.15,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              _action.toUpperCase(),
              style: TextStyle(fontSize: Dimens.font_sp12,fontWeight: FontWeight.bold,color: Colours.text_gray),
            ),
            VerticalDivider(
              color: Colours.text_gray,
            ),
          ],
        ),
      ),
      title: Text(_account?.accountHolderName ??
          AppLocalizations.of(context).selectAccount+(isSource?' Source':' Destination')),
      dense: true,
      subtitle: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _account?.accountNumberMasked ??
                    '',
                style: TextStyles.textSize10,
              ),
              Gaps.vGap5,
              Visibility(
                visible:_account?.productType != null ?true:false,
                child: Text(
                  _account?.productType != null
                      ? (_account?.productType == 'PrepaidCard'
                      ? "Prepaid Card"
                      : _account?.productType == 'CreditCard'
                      ? "Credit Card"
                      : _account.productType == 'DebitCard'
                      ? "Debit Card"
                      : "")
                      : "",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: Dimens.font_sp10),
                ),
              ),
            ]
        ),
      ),
      trailing: getWalletIcon(_account.imageUrl),
    );
  }
}
Widget getWalletIcon(String image) {
  String img = image??"";
  Widget widget;
  if (img.isNotEmpty) {
    widget = Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(img),
          fit: BoxFit.scaleDown,
          scale: 1,
        ),
      ),
    );
  }else {
    widget = new Image.asset(
      'assets/images/cards/default_card.png',
      width: 32.0,
    );
  }
  return widget;
}
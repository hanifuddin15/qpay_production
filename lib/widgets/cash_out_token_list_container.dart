import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/utils.dart';

import 'my_dialog.dart';

class CashOutTokenListContainer extends StatelessWidget{
  BuildContext context;
  List<CashOutTokenViewModel> _cashOutTokens  = List<CashOutTokenViewModel>();
  final Function(CashOutTokenViewModel) onSelect;
  final Function onRefresh;

  CashOutTokenListContainer(this.context, this._cashOutTokens,this.onSelect,this.onRefresh);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
          itemCount: _cashOutTokens?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(8),
              child: DottedBorder(
                color: Colors.redAccent,
                strokeWidth: 1,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _cashOutTokens[index]?.token ?? "",
                          style: /*_cashOutTokens[index]?.status == 'Withdrawn'
                              ? TextStyles.textBold24StrikeTrough
                              : */TextStyles.textBold24,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "৳ " + _cashOutTokens[index]?.amount ?? "",
                                style: TextStyles.textBold14Coupon,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Visibility(
                                  visible: /*_cashOutTokens[index]?. isExtendable*/false,
                                  child: ButtonTheme(
                                    minWidth: 60,
                                    height: 30,
                                    child: OutlinedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).extendThis,
                                        style: TextStyles.textSize10,
                                      ),
                                      onPressed: ()=>onSelect(_cashOutTokens[index]),
                                    ),
                                  ),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Transaction ID: ",
                          style: TextStyles.text,
                        ),
                        SelectableText(
                          _cashOutTokens[index]?.transactionId ?? "",
                          cursorColor: Colors.red,
                          showCursor: false,
                          toolbarOptions: ToolbarOptions(
                              copy: true,
                              selectAll: true,
                              cut: false,
                              paste: false
                          ),
                          style: TextStyles.textBold12,
                          ),
                      ],
                    ),
                    Gaps.vGap8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).cashOutTokenExpireTime,
                          style: TextStyles.textGray12,
                        ),
                        Text(
                          _cashOutTokens[index]?.expirationTime ?? "",
                          style: TextStyles.textGray12,
                        ),
                      ],
                    ),
                    Gaps.vGap8,
                  ],
                ),
              ),
            );
          }),
    );
  }


}
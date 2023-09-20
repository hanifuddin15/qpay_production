import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/res/styles.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/transaction_description_widget.dart';
import 'package:qpay/widgets/transaction_detail_dialog_row_component.dart';
import 'package:qpay/widgets/transaction_detaile_dialog.dart';

import 'account_selector.dart';

class TransactionListContainer extends StatelessWidget{
  BuildContext context;
  List<TransactionViewModel> _transactions = List<TransactionViewModel>();


  TransactionListContainer(this.context,this._transactions);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.gap_dp8),
      child: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: ()=>{
              _showSuccessDialog(_transactions[index])
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colours.statementBg,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gaps.vGap8,
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    _transactions[index].transactionName,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: _transactions[index].transactionStatus=="Success" ?Colors.green:_transactions[index].transactionStatus=="Declined" ?Colors.red:_transactions[index].transactionStatus== "Processing"?Colors.blue:Colors.black,
                                        fontSize: Dimens.font_sp14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter'),
                                  ),
                                ],
                              )),
                          Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                        "BDT " +
                                        _transactions[index].amountFormatted,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: _transactions[index].reflection== "in"? Colors.green: Colors.red,
                                        fontSize: Dimens.font_sp14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter'),
                                  ),
                                  Gaps.hGap4,
                                  ImageIcon(
                                    _transactions[index].reflection == "in"?
                                    AssetImage('assets/images/in_txn.png'):AssetImage('assets/images/out_txn.png'),
                                    size: 10,
                                    color: _transactions[index].reflection == "in"? Colors.green: Colors.red,
                                  )
                                ],
                              )),
                        ]),
                    Gaps.vGap8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _transactions[index].dateTime??AppLocalizations.of(context).notAvailable,
                          style:
                          TextStyle(color: Colours.text_gray, fontSize: Dimens.font_sp12,fontFamily: 'Inter'),
                        ),
                        Text(
                          "Tnx ID: " + _transactions[index].transactionId,
                          style:
                          TextStyle(color: Colours.text_gray, fontSize: Dimens.font_sp12,fontFamily: 'Inter'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog(TransactionViewModel transactionViewModel) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return TransactionDetailDialog(
            actionText: AppLocalizations.of(context).okay,
            statusImage: transactionViewModel.transactionStatus=="Success" ? 'successful_icon':transactionViewModel.transactionStatus== "Declined"? 'dispute_icon':transactionViewModel.transactionStatus== "Processing" ? 'processing_icon':'failure_icon',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                transactionViewModel.transactionName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp20,
                                    color: transactionViewModel.transactionStatus=="Success" ?Colors.green:transactionViewModel.transactionStatus== "Declined"?Colors.red:transactionViewModel.transactionStatus== "Processing"?Colors.blue:Colors.black
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gaps.vGap16,
                      TransactionAmountDescriptionWidget(transactionViewModel),
                      Gaps.vGap4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Transaction ID",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp12,
                                    color: Colours.text_gray
                                ),
                              ),
                              Gaps.vGap4,
                              SelectableText(
                                transactionViewModel.transactionId??AppLocalizations.of(context).notAvailable,
                                cursorColor: Colors.red,
                                showCursor: false,
                                toolbarOptions: ToolbarOptions(
                                    copy: true,
                                    selectAll: true,
                                    cut: false,
                                    paste: false
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp14,
                                    color: Colours.text
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gaps.vGap4,
                      TransactionDetailDialogRowLayout(header: 'Date & Time', description: transactionViewModel.dateTime??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap4,
                      TransactionDetailDialogRowLayout(header: 'From Account', description: transactionViewModel.debitAccount.toUpperCase()??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap4,
                      TransactionDetailDialogRowLayout(header: 'To Account', description: transactionViewModel.creditAccount.toUpperCase()??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap4,
                      TransactionDetailDialogRowLayout(header: 'Approval Code', description: transactionViewModel.approvalCode??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap4,
                      TransactionDetailDialogRowLayout(header: 'Status', description: transactionViewModel.transactionStatus??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap4,
                      Visibility(
                          visible: transactionViewModel.transactionName.toLowerCase()=='bkash cash in'&&transactionViewModel.transactionStatus.toLowerCase()=='success',
                          child: TransactionDetailDialogRowLayout(header: 'bKash OID', description: transactionViewModel.referenceInfo??AppLocalizations.of(context).notAvailable)),
                      Gaps.vGap4,
                      TransactionDetailDialogRowLayout(header: 'Remarks',description: transactionViewModel.transactionDetails??AppLocalizations.of(context).notAvailable,),
                      Gaps.vGap4,
                      TransactionDetailDialogRowLayout(header: 'Purpose',description: transactionViewModel.remarks??AppLocalizations.of(context).notAvailable,),
                    ],
                  ),
                ),
              ],
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }
}
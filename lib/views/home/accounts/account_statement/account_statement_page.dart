import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_statement_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/providers/emi_request_state_provider.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/account_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/utils.dart';

import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/small_button.dart';
import 'package:qpay/widgets/transaction_detaile_dialog.dart';

import 'account_statement_iview.dart';
import 'account_statement_page_presenter.dart';

class AccountStatementPage extends StatefulWidget {

  _AccountBalancePageState createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountStatementPage>
    with
        BasePageMixin<AccountStatementPage, AccountStatementPagePresenter>,
        AutomaticKeepAliveClientMixin<AccountStatementPage>
    implements AccountStatementIMvpView {
  List<AccountStatementViewModel> _accountStatement =
      <AccountStatementViewModel>[];
  LinkedAccountViewModel account = StatementAccountSelectionListener().selectedAccount;
  final emiRequestData = EmiRequestStateProvider();

  @override
  void initState() {
    super.initState();
    emiRequestData.addListener((){});
  }

  @override
  void dispose() {
    emiRequestData.removeListener((){});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(
            centerTitle: AppLocalizations.of(context).accountStatement,
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(Dimens.gap_dp12),
      child: ListView.builder(
        itemCount: _accountStatement.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: ()=>{
              _showSuccessDialog(_accountStatement[index])
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
                    Gaps.vGap4,
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    _accountStatement[index].description??AppLocalizations.of(context).notAvailable,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colours.text,
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
                                  _accountStatement[index].amount??AppLocalizations.of(context).notAvailable,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: _accountStatement[index].reflection == "in"? Colors.green :Colors.red,
                                      fontSize: Dimens.font_sp14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter'),
                                ),
                                Gaps.hGap4,
                                ImageIcon(
                                  _accountStatement[index].reflection == "in"?
                                  AssetImage('assets/images/in_txn.png'):AssetImage('assets/images/out_txn.png'),
                                  size: 10,
                                  color: _accountStatement[index].reflection == "in"? Colors.green: Colors.red,
                                ),
                              ],
                            ),),
                        ]),
                    Gaps.vGap4,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _accountStatement[index].transactionTime??AppLocalizations.of(context).notAvailable,
                          style:
                          TextStyle(color: Colours.text_gray, fontSize: Dimens.font_sp12,fontFamily: 'Inter'),
                        ),
                        Text(
                          "Tnx ID: " + _accountStatement[index].transactionId??AppLocalizations.of(context).notAvailable,
                          style:
                          TextStyle(color: Colours.text_gray, fontSize: Dimens.font_sp12,fontFamily: 'Inter'),
                        )
                      ],
                    ),
                    Gaps.vGap4,
                    Visibility(
                      visible:  _accountStatement[index].isEmiApplicable,
                      child: Column(
                        children: [
                          Gaps.line,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context).emiAvailCondition,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colours.text_gray,
                                        fontSize: Dimens.font_sp12,
                                        fontFamily: 'Inter'),
                                  ),
                                ),
                                SmallButton(
                                  text: AppLocalizations.of(context).emiAvail,
                                  onPressed: () {
                                    _next(index);

                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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

  void _next(int index){
      emiRequestData.setEmiRequestData(_accountStatement[index].transactionId, _accountStatement[index].description, _accountStatement[index].transactionTime,_accountStatement[index].amount, _accountStatement[index].amountAcct, _accountStatement[index].location, _accountStatement[index].transactionCode, _accountStatement[index].approvalCode,_accountStatement[index].terminal);
      NavigatorUtils.push(context, AccountRouters.accountEmi);
  }

  void _showSuccessDialog(AccountStatementViewModel statementViewModel) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return TransactionDetailDialog(
            actionText: AppLocalizations.of(context).okay,
            statusImage:  'successful_icon',
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                statementViewModel.description?.toUpperCase()??AppLocalizations.of(context).notAvailable,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp20,
                                    color: Colors.green
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gaps.vGap16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp12,
                                    color: Colours.text_gray
                                ),
                              ),
                              Gaps.vGap4,
                              Row(
                                children: [
                                  Text(
                                    statementViewModel.amount.toUpperCase()??AppLocalizations.of(context).notAvailable,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimens.font_sp14,
                                        color: statementViewModel.reflection == "in"?Colors.green:Colors.red
                                    ),
                                  ), Gaps.hGap8,
                                  ImageIcon(
                                    statementViewModel.reflection == "in"?
                                    AssetImage('assets/images/in_txn.png'):AssetImage('assets/images/out_txn.png'),
                                    size: 10,
                                    color: statementViewModel.reflection == "in"? Colors.green: Colors.red,
                                  )

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gaps.vGap4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Amount in Transaction Currency",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp12,
                                    color: Colours.text_gray
                                ),
                              ),
                              Gaps.vGap4,
                              Text(
                                statementViewModel.amountAcct.toUpperCase()??AppLocalizations.of(context).notAvailable,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
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
                                statementViewModel.transactionId??AppLocalizations.of(context).notAvailable,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Approval Code",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp12,
                                    color: Colours.text_gray
                                ),
                              ),
                              Gaps.vGap4,
                              Text(
                                statementViewModel.approvalCode??AppLocalizations.of(context).notAvailable,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Terminal Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp12,
                                    color: Colours.text_gray
                                ),
                              ),
                              Gaps.vGap4,
                              Text(
                                statementViewModel.terminal??AppLocalizations.of(context).notAvailable,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Location",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp12,
                                    color: Colours.text_gray
                                ),
                              ),
                              Gaps.vGap4,
                              Text(
                                statementViewModel.location??AppLocalizations.of(context).notAvailable,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Date & Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.font_sp12,
                                    color: Colours.text_gray
                                ),
                              ),
                              Gaps.vGap4,
                              Text(
                                statementViewModel.transactionTime??AppLocalizations.of(context).notAvailable,
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

  @override
  AccountStatementPagePresenter createPresenter() {
    return AccountStatementPagePresenter();
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void setAccountStatement(List<AccountStatementViewModel> accountStatement) {
    if(mounted) {
      setState(() {
        _accountStatement = accountStatement;
      });
    }
  }
}

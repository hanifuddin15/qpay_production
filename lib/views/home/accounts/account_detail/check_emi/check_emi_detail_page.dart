import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_emi_detail_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/views/home/accounts/account_detail/check_emi/check_emi_detail_iview.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/card_background_widget.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/transaction_detail_dialog_row_component.dart';
import 'package:qpay/widgets/transaction_detaile_dialog.dart';

import 'check_emi_detail_presenter.dart';

class CheckEMIDetailPage extends StatefulWidget{
  @override
  _CheckEMIDetailPageState createState() => _CheckEMIDetailPageState();
  
}

class _CheckEMIDetailPageState extends State<CheckEMIDetailPage>
    with BasePageMixin<CheckEMIDetailPage,CheckEMIDetailPagePresenter>,
        AutomaticKeepAliveClientMixin<CheckEMIDetailPage>
    implements CheckEMIDetailIMvpView{
  List<AccountEMIDetailViewModel> _accountEMIList = <AccountEMIDetailViewModel>[];
  LinkedAccountViewModel account = AccountSelectionListener().selectedAccount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).emiDetails,
        ),
        body: MyScrollView(children: [_buildBody()]),

      ),
    );
  }
  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Transform.scale(
            scale: .85,
            child: CardBackgroudView(
                context: context,
                cardType: CardUtils.getCardTypeFrmNumber(
                    account.accountNumberMasked.trim()),
                cardIssuedBankImage: account.imageUrl,
                cardIssuedBank:account.instituteName,
                cardNumber: account.accountNumberMasked,
                cardHolder: account.accountHolderName,
                cardExpiration: account.expiryDate),
          ),
          Gaps.vGap24,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Created Date ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colours.app_main),
                          )),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "EMI Amount",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colours.app_main),
                          )),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: _accountEMIList.length??0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            _showSuccessDialog(_accountEMIList[index]);
                          },
                          child: Card(
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEmiDetailCard(
                                  date: _accountEMIList[index]?.createdAt??AppLocalizations.of(context).notAvailable,
                                  emiAmount: _accountEMIList[index]?.emiAmount??AppLocalizations.of(context).notAvailable,
                                ),],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  @override
  CheckEMIDetailPagePresenter createPresenter() => CheckEMIDetailPagePresenter();

  @override
  void setEMIDetailsList(List<AccountEMIDetailViewModel> accountEMIDetail) {
   if(mounted) {
     setState(() {
       _accountEMIList = accountEMIDetail;
     });
   }
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildEmiDetailCard({
    @required String date,
    @required String emiAmount,
  }) {
    return Container(
      width:MediaQuery.of(context).size.width*.9,
      height: MediaQuery.of(context).size.height*.085,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Align(
              alignment: Alignment.center,
              child: Text(date,softWrap: true,textAlign: TextAlign.center,
                maxLines: 2,),
            ),
          ),
          Flexible(
            child: Align(
                alignment: Alignment.center,
                child: Text(emiAmount,softWrap: true,textAlign: TextAlign.center,
                  maxLines: 2,style: TextStyle(fontSize:Dimens.font_sp14,),)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(AccountEMIDetailViewModel accountEMIDetailViewModel) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return TransactionDetailDialog(
            actionText: AppLocalizations.of(context).okay,
            statusImage: 'emi_detail_icon',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gaps.vGap24,
                      TransactionDetailDialogRowLayout(header: 'Created Date', description: accountEMIDetailViewModel.createdAt??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap8,
                      TransactionDetailDialogRowLayout(header: 'EMI Amount', description: accountEMIDetailViewModel.emiAmount??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap8,
                      TransactionDetailDialogRowLayout(header: 'Merchant Name', description: accountEMIDetailViewModel.merchantName??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap8,
                      TransactionDetailDialogRowLayout(header: 'Monthly EMI ', description: accountEMIDetailViewModel.installmentAmount??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap8,
                      TransactionDetailDialogRowLayout(header: 'Unpaid EMI Amount', description: accountEMIDetailViewModel.unPaidAmount??AppLocalizations.of(context).notAvailable),
                      Gaps.vGap8,
                      TransactionDetailDialogRowLayout(header: 'Unpaid Cycle',description: accountEMIDetailViewModel.unPaidCycle+' months'??AppLocalizations.of(context).notAvailable,),
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
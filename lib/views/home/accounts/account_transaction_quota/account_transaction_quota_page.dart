import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/card_status_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_quota_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/card_background_widget.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'account_transaction_quota_iview.dart';
import 'account_transaction_quota_page_presenter.dart';

class AccountTransactionQuotaPage extends StatefulWidget{

  @override
  _AccountTransactionQuotaPageState createState() => _AccountTransactionQuotaPageState();

}
class _AccountTransactionQuotaPageState extends State<AccountTransactionQuotaPage>
  with BasePageMixin<AccountTransactionQuotaPage,AccountTransactionQuotaPagePresenter>,
      AutomaticKeepAliveClientMixin<AccountTransactionQuotaPage> implements AccountTransactionQuotaIMvpView{

  LinkedAccountViewModel account = AccountSelectionListener().selectedAccount;
  List<TransactionQuotaViewModel> _transactionQuota =
  <TransactionQuotaViewModel>[];
  CardStatusViewModel _cardStatusViewModel;
  int isLocalEnable ;
  int isForeignEnable;
  String cardStatus = '';

  @override
  void initState() {
    isLocalEnable = 1;
    isForeignEnable =1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          isBack: true,
          centerTitle: AppLocalizations.of(context).transactionControl.toUpperCase(),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody(){
    return Column(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*.65,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyCheckButton(
                    key: const Key('confirm'),
                    onPressed: _checkCardStatus ,
                    text: AppLocalizations.of(context).checkCardStatus,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  cardStatus.toUpperCase(),
                  style: TextStyle(color: Colours.app_main,fontWeight: FontWeight.bold,fontSize: Dimens.font_sp18),
                ),
              )
            ],
          ),
        ),
        Gaps.vGap12,
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Local TXN Enable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: 'SF'),),
                           ],
                         ),
                         ToggleSwitch(
                           totalSwitches: 3,
                           initialLabelIndex: isLocalEnable,
                           activeBgColor: [Colors.green],
                           activeFgColor: Colors.white,
                           inactiveBgColor: Colours.dashboard_bg,
                           inactiveFgColor: Colors.black,
                           minWidth: 60,
                           labels: ['Off', 'None', 'On'],
                           onToggle: (index) {
                             if(mounted) {
                               setState(() {
                                 switch (index) {
                                   case 0:
                                     isLocalEnable = index;
                                     _submit("bdt", false);
                                     break;
                                   case 2:
                                     isLocalEnable = index;
                                     _submit("bdt", true);
                                     break;
                                 }
                               });
                             }
                           },
                         ),
                       ],
                     ),
                   ),
                   Gaps.vGap12,
                   Gaps.line,
                   Gaps.vGap12,
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Foreign TXN Enable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: 'SF'),),

                           ],
                         ),
                         ToggleSwitch(
                           totalSwitches: 3,
                           initialLabelIndex: isForeignEnable,
                           activeBgColor: [Colors.green],
                           activeFgColor: Colors.white,
                           inactiveBgColor: Colours.dashboard_bg,
                           inactiveFgColor: Colors.black,
                           minWidth: 60,
                           labels: ['Off', 'None', 'On'],
                           onToggle: (index) {
                             if(mounted) {
                               setState(() {
                                 switch (index) {
                                   case 0:
                                     isForeignEnable = index;
                                     _submit("usd", false);
                                     break;
                                   case 2:
                                     isForeignEnable = index;
                                     _submit("usd", true);
                                     break;
                                 }
                               });
                             }
                           },
                         ),
                             /*CupertinoSwitch(activeColor: Colours.activeColor,value: isForeignEnable, onChanged: (bool isOn){
                             setState(() {
                               isForeignEnable =  isOn;
                               if(isForeignEnable){
                                 _submit("usd", isForeignEnable);
                               }else{
                                 _submit("usd", isForeignEnable);
                               }
                             });
                           }),*/
                       ],
                     ),
                   ),
                   Gaps.vGap32,
                   Gaps.vGap24,
                   MyButton(
                     key: const Key('confirm'),
                     onPressed: _checkStatus,
                     text: AppLocalizations.of(context).checkStatus,
                   ),
                 ],
               ),
             ],
           ),
        ),
      ],
    );
  }
  void _checkStatus() async{
    final int cardId = account.id;
    var response = await presenter.tqEnquiry(cardId);
    if(mounted && response != null){
      setState(() {
        _transactionQuota = response;
        isLocalEnable = response[0].status ==1 ? 2 : 0;
        isForeignEnable = response[1].status == 1 ? 2 : 0;
      });
    }
  }



  void _checkCardStatus() async{
    int accountId = account.id;
    var response = await presenter.getStatus(accountId);
    if(response!=null){
      _cardStatusViewModel = response;
      if(mounted && _cardStatusViewModel.cardStatus!=null) {
        setState(() {
          cardStatus = _cardStatusViewModel.cardStatus;
        });
      }
    }
  }


  void _submit(String quotaType, bool enable) async{
    final int cardId = account.id;
    final String quota = quotaType;
    final bool isEnable = enable;
    var response = await presenter.tqRequest(cardId, quota, isEnable);
    if(response != null){
      if(response.isSuccess) {
        showSuccessDialog("Payment procedure modified");
      }else{
        showErrorDialog("Payment procedure can not be modified");
      }
    }
  }

  @override
  AccountTransactionQuotaPagePresenter createPresenter() {
   return AccountTransactionQuotaPagePresenter();
  }

  @override
  bool get wantKeepAlive => false;
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/views/home/accounts/account_balance/account_balance_iview.dart';
import 'package:qpay/views/home/accounts/account_balance/account_balance_page_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/card_background_widget.dart';
import 'package:qpay/widgets/daily_limit_container.dart';
import 'package:qpay/widgets/monthly_limit_container.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

class AccountBalancePage extends StatefulWidget{
  _AccountBalancePageState createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage>
      with BasePageMixin<AccountBalancePage,AccountBalancePagePresenter>,
AutomaticKeepAliveClientMixin<AccountBalancePage> implements AccountBalanceIMvpView{
  List<AccountBalanceViewModel> _accountBalance = <AccountBalanceViewModel>[];
  LinkedAccountViewModel account = AccountSelectionListener().selectedAccount;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
            appBar: MyAppBar(
              centerTitle: AppLocalizations.of(context).cardBalance,
            ),
            body: MyScrollView(children: [_buildBody()]),

      ),
    );
  }

  Widget _buildBody() {
     return Container(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
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
             padding: EdgeInsets.all(Dimens.gap_dp8),
             child: ListView.builder(
               shrinkWrap: true,
               physics: ScrollPhysics(),
                  itemCount: _accountBalance.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0.3,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gaps.vGap8,
                            // Text("Customer Account Number:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                            // Gaps.vGap8,
                            // Text(_accountBalance[index].accountNumber,style: TextStyle(color: Colours.textBlueColor,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: 'SF'),),
                            // Gaps.vGap12,
                           /* Gaps.line,
                            Gaps.vGap8,
                            Text("Hold Amount:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                            Gaps.vGap8,
                            Text(_accountBalance[index].currency+" " + _accountBalance[index].holdAmount,style: TextStyle(color: Colours.textBlueColor,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: 'SF'),),
                            Gaps.vGap12,*/
                            Gaps.line,
                            Gaps.vGap8,
                            Text("Available Balance:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                            Gaps.vGap8,
                            Text(_accountBalance[index].currency+" " + _accountBalance[index].balance,style: TextStyle(color: Colours.textBlueColor,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: 'SF'),),
                            Gaps.vGap12,
                            Gaps.line,
                          ],
                        ),
                      ),
                    );
                  },
                ),
           ),
         ],
       ),
     );
  }


  @override
  AccountBalancePagePresenter createPresenter() {
    return AccountBalancePagePresenter();
  }


  @override
  bool get wantKeepAlive => false;

  @override
  void setAccountBalance(List<AccountBalanceViewModel> accountBalance) {
    if(mounted) {
      setState(() {
        _accountBalance = accountBalance;
      });
    }
  }


}
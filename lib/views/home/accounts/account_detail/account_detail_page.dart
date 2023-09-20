

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_detail_vm.dart';
import 'package:qpay/net/contract/card_status_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/reference_vm.dart';
import 'package:qpay/net/contract/reward_point_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/account_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/card_background_widget.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

import 'account_detail_iview.dart';
import 'account_detail_page_presenter.dart';

class AccountDetailPage extends StatefulWidget{
  _AccountDetailPageState createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage>
      with BasePageMixin<AccountDetailPage,AccountDetailPagePresenter>,
AutomaticKeepAliveClientMixin<AccountDetailPage>
    implements AccountDetailIMvpView{
  AccountDetailViewModel _accountDetail;
  LinkedAccountViewModel account = AccountSelectionListener().selectedAccount;
  RewardPointViewModel _rewardPointViewModel;
  String rewardPoint = '';

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
    return SafeArea(
      child: Scaffold(
            appBar: MyAppBar(
              centerTitle: AppLocalizations.of(context).statementDetails,
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
             child: Column(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Gaps.vGap12,
                 Gaps.line,
                 Gaps.vGap8,
                 Row(
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Statement Date:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                     Text(_accountDetail?.statementDate??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.textBlueColor,fontSize: Dimens.font_sp16,fontWeight: FontWeight.normal,fontFamily: 'SF'),),
                   ],
                 ),
                 Gaps.vGap12,
                 Gaps.line,
                 Gaps.vGap8,
                 Row(
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Payment Due Date:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                     Text(_accountDetail?.paymentDueDate??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.textBlueColor,fontSize:Dimens.font_sp16,fontWeight: FontWeight.normal,fontFamily: 'SF'),),
                   ],
                 ),
                 Gaps.vGap12,
                 Gaps.line,
                 Gaps.vGap8,
                 SingleChildScrollView(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: <Widget>[
                     DefaultTabController(
                     length: 2,
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: <Widget>[
                         Container(
                           child: TabBar(tabs: [
                             Tab(text: "BDT"),
                             Tab(text: "USD"),
                           ]),
                         ),
                         Container(
                           //Add this to give height
                           height: MediaQuery.of(context).size.height*.2,
                           child: TabBarView(children: [
                             Container(
                               child: Card(
                                 elevation: 3,
                                 child: Container(
                                   width: MediaQuery.of(context).size.width,
                                   margin: EdgeInsets.all( 8.0),
                                   child: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         mainAxisSize: MainAxisSize.max,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text("Credit Limit:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                                           Text(_accountDetail?.bdt?.creditLimit??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.textBlueColor,fontSize: Dimens.font_sp16,fontWeight: FontWeight.normal,fontFamily: 'SF'),),
                                         ],
                                       ),
                                       Gaps.vGap16,
                                       Row(
                                         mainAxisSize: MainAxisSize.max,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text("Statement Outstanding:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                                           Text(_accountDetail?.bdt?.outstanding??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.textBlueColor,fontSize: Dimens.font_sp16,fontWeight: FontWeight.normal,fontFamily: 'SF'),),
                                         ],
                                       ),
                                       Gaps.vGap16,
                                       Row(
                                         mainAxisSize: MainAxisSize.max,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text("Minimum Payment:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                                           Text(_accountDetail?.bdt?.minPayment??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.textBlueColor,fontSize: Dimens.font_sp16,fontWeight: FontWeight.normal,fontFamily: 'SF'),),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             ),
                             Container(
                               child: Card(
                                 elevation: 3,
                                 child: Container(
                                   width: MediaQuery.of(context).size.width,
                                   margin: EdgeInsets.all( 8.0),
                                   child: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         mainAxisSize: MainAxisSize.max,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text("Credit Limit:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                                           Text(_accountDetail?.usd?.creditLimit??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.textBlueColor,fontSize:Dimens.font_sp16,fontWeight: FontWeight.normal,fontFamily: 'SF'),),
                                         ],
                                       ),
                                       Gaps.vGap16,
                                       Row(
                                         mainAxisSize: MainAxisSize.max,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text("Statement Outstanding:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                                           Text(_accountDetail?.usd?.outstanding??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.textBlueColor,fontSize: Dimens.font_sp16,fontWeight: FontWeight.normal,fontFamily: 'SF'),),
                                         ],
                                       ),
                                       Gaps.vGap16,
                                       Row(
                                         mainAxisSize: MainAxisSize.max,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text("Minimum Payment:",style: TextStyle(color: Colours.text_gray,fontSize: 12.0,fontFamily: 'SF'),),
                                           Text(_accountDetail?.usd?.minPayment??AppLocalizations.of(context).notAvailable,style: TextStyle(color: Colours.textBlueColor,fontSize:Dimens.font_sp16,fontWeight: FontWeight.normal,fontFamily: 'SF'),),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             ),
                           ]),
                         ),
                       ],
                     ),
                   ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
           Gaps.vGap12,
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
                       onPressed: _checkReward ,
                       text: AppLocalizations.of(context).checkReward,
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                   child: Text(
                     rewardPoint,
                     style: TextStyle(color: Colours.app_main,fontWeight: FontWeight.bold,fontSize: Dimens.font_sp18),
                   ),
                 )
               ],
             ),
           ),
           Gaps.vGap12,
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               mainAxisSize: MainAxisSize.max,
               children: [
                 Container(
                   width: MediaQuery.of(context).size.width*.65,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: MyCheckButton(
                       key: const Key('confirm'),
                       onPressed: _checkEMI ,
                       text: AppLocalizations.of(context).checkEMI,
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
  }

  void _checkReward() async{
    int accountId = account.id;
    var response = await presenter.getReward(accountId);
    if(response!=null){
      _rewardPointViewModel = response;
      if(mounted && _rewardPointViewModel.rewardPoint!=null) {
        setState(() {
          rewardPoint = _rewardPointViewModel.rewardPoint;
        });
      }
    }
  }

  void _checkEMI(){
    if(account != null){
      AccountSelectionListener().setAccount(account);
      NavigatorUtils.push(context, AccountRouters.accountEmiDetail);
    }
  }

  @override
  AccountDetailPagePresenter createPresenter() {
    return AccountDetailPagePresenter();
  }


  @override
  bool get wantKeepAlive => false;

  @override
  void setAccountDetail(AccountDetailViewModel accountDetail) {
   if(mounted) {
     setState(() {
       _accountDetail = accountDetail;
     });
   }
  }
}
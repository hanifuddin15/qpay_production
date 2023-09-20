import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/widgets/accounts_container.dart';
import 'accounts_iview.dart';
import 'accounts_page_presenter.dart';

class CardsSelectorPage extends StatefulWidget {
  String type;
  int selectedAccountId;
  String cardType;
  bool pgHide;
  @override
  _CardsSelectorPageState createState() => _CardsSelectorPageState();

  CardsSelectorPage(this.type,{this.selectedAccountId=0,this.cardType='',this.pgHide=false});
}

class _CardsSelectorPageState extends State<CardsSelectorPage>
    with
        BasePageMixin<CardsSelectorPage, AccountsPagePresenter>,
        AutomaticKeepAliveClientMixin<CardsSelectorPage>
    implements AccountsIMvpView{

  List<LinkedAccountViewModel> _cards = <LinkedAccountViewModel>[];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 1,
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colours.app_main, //change your color here
                ),
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                      labelColor: Colours.app_main,
                      unselectedLabelColor: Colours.text_gray,
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context).ownCards,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                AccountsContainer(_cards,_selectAccount),
              ])),
        ),
      ),
    );
  }

  @override
  AccountsPagePresenter createPresenter() {
    return AccountsPagePresenter();
  }

  @override
  void setAccounts(List<LinkedAccountViewModel> accounts) {
    if(mounted) {
      setState(() {
        if(widget.type == Constant.transactionAccountSelector && !widget.pgHide){
          _cards = accounts.where((element) => element.isCard() && element.ownershipType == "Personal"&&
              (widget.cardType !=null ? element.productType != widget.cardType.split('|').first && element.productType != widget.cardType.split('|').last:element.productType != widget.cardType)&& element.id != widget.selectedAccountId).toList();
        }
        else{
          _cards = accounts.where((element) => element.isCard() && element.ownershipType == "Personal"&& element.id != -100 &&
            (widget.cardType !=null ? element.productType != widget.cardType.split('|').first && element.productType != widget.cardType.split('|').last:element.productType != widget.cardType)&& element.id != widget.selectedAccountId).toList();
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  _selectAccount(LinkedAccountViewModel account) {
    if(account!=null){
      switch(widget.type){
        case Constant.accountDetailSelector:
          AccountSelectionListener().setAccount(account);
          break;
        case Constant.qpayTransactionHistoryAccountSelector:
          QpayTransactionSelectorAccountSelectionListener().setAccount(account);
          break;
        case Constant.statementAccountSelector:
          StatementAccountSelectionListener().setAccount(account);
          break;
        default:
          TransactionAccountSelectionListener().setAccount(account);
          break;
      }
    }
    NavigatorUtils.goBack(context);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/views/home/accounts/accounts_iview.dart';
import 'package:qpay/views/home/accounts/accounts_page_presenter.dart';
import 'package:qpay/widgets/accounts_container.dart';

class AllAccountSelectorPage extends StatefulWidget {
  String listenerType;
  String transactionType;
  int selectedAccountId = 0;
  String cardType='';
  @override
  _AllAccountSelectorPageState createState() => _AllAccountSelectorPageState();

  AllAccountSelectorPage(this.listenerType,this.transactionType,{this.selectedAccountId,this.cardType});
}

class _AllAccountSelectorPageState extends State<AllAccountSelectorPage>
    with
        BasePageMixin<AllAccountSelectorPage, AccountsPagePresenter>,
        AutomaticKeepAliveClientMixin<AllAccountSelectorPage>
    implements AccountsIMvpView{

  List<LinkedAccountViewModel> _beneficiaryCards =
  <LinkedAccountViewModel>[];
  List<LinkedAccountViewModel> _cards = <LinkedAccountViewModel>[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
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
                      Tab(
                        text: AppLocalizations.of(context).beneficiaries,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              AccountsContainer(_cards,_selectAccount),
              AccountsContainer(_beneficiaryCards,_selectAccount,isBeneficiary: true,),
            ])),
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
        if (widget.transactionType == 'card_bill') {
          _beneficiaryCards =
              accounts.where((element) =>
              element.financialAccountType == 'Card' &&
                  element.ownershipType == "Beneficiary" &&
                  (widget.cardType != null ? element.productType !=
                      widget.cardType
                          .split('|')
                          .first && element.productType != widget.cardType
                      .split('|')
                      .last : element.productType != widget.cardType) &&
                  element.id != widget.selectedAccountId)
                  .toList();
          _cards = accounts.where((element) =>
          element.isCard() &&
              element.ownershipType == "Personal" &&
              element.productType == "CreditCard" &&
              element.id != -100 &&
              element.id != widget.selectedAccountId).toList();
        } else {
          _beneficiaryCards =
              accounts.where((element) =>
              element.financialAccountType != 'Wallet' &&
                  element.productType != "CreditCard" &&
                  element.ownershipType == "Beneficiary")
                  .toList();
          _cards = accounts.where((element) =>
          element.isCard() &&
              element.ownershipType == "Personal" &&
              element.productType != "CreditCard" &&
              element.id != -100 &&
              element.id != widget.selectedAccountId).toList();
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  _selectAccount(LinkedAccountViewModel account) {
    if(account!=null){
      switch(widget.listenerType){
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

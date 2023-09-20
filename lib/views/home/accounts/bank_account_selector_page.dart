
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

class BankAccountSelectorPage extends StatefulWidget {
  String type;
  @override
  _BankAccountSelectorPageState createState() => _BankAccountSelectorPageState();
  BankAccountSelectorPage(this.type);
}

class _BankAccountSelectorPageState extends State<BankAccountSelectorPage>
    with
        BasePageMixin<BankAccountSelectorPage, AccountsPagePresenter>,
        AutomaticKeepAliveClientMixin<BankAccountSelectorPage>
    implements AccountsIMvpView{

  List<LinkedAccountViewModel> _bankAccounts =
  <LinkedAccountViewModel>[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 1,
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                      labelColor: Colours.app_main,
                      unselectedLabelColor: Colours.text_gray,
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context).banks,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                AccountsContainer(_bankAccounts,_selectAccount),
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
        _bankAccounts =
            accounts.where((element) => element.financialAccountType == "Bank")
                .toList();
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
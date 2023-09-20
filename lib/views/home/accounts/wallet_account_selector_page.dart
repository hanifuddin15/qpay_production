import 'package:flutter/material.dart';
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

class WalletAccountSelectorPage extends StatefulWidget {
  String listenerType;
  String transactionType;
  @override
  _WalletAccountSelectorPageState createState() => _WalletAccountSelectorPageState();

  WalletAccountSelectorPage(this.listenerType,this.transactionType);
}

class _WalletAccountSelectorPageState extends State<WalletAccountSelectorPage>
    with
        BasePageMixin<WalletAccountSelectorPage, AccountsPagePresenter>,
        AutomaticKeepAliveClientMixin<WalletAccountSelectorPage>
    implements AccountsIMvpView{

  List<LinkedAccountViewModel> _beneficiaryWallet =
  <LinkedAccountViewModel>[];

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
                          text: AppLocalizations.of(context).beneficiaryWallets,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                AccountsContainer(_beneficiaryWallet,_selectAccount,isBeneficiary: true,),
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
        _beneficiaryWallet =
            accounts.where((element) =>
            element.ownershipType == "Beneficiary" &&
                element.financialAccountType == "Wallet")
                .toList();
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

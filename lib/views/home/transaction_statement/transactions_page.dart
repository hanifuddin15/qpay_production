import 'package:flutter/material.dart';
import 'package:qpay/Events/transaction_success_event.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/account_linked_vm.dart';
import 'package:qpay/net/contract/account_statement_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/application.dart';
import 'package:qpay/static_data/app_event_bus.dart';
import 'package:qpay/utils/card_utils.dart';
import 'package:qpay/views/home/accounts/accounts_page_presenter.dart';
import 'package:qpay/views/home/accounts/card_selector_page.dart';
import 'package:qpay/views/home/transaction_statement/transaction_iview.dart';
import 'package:qpay/views/home/transaction_statement/transactions_page_presenter.dart';
import 'package:qpay/widgets/account_selector.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/small_button.dart';
import 'package:qpay/widgets/statement_list_container.dart';
import 'package:qpay/widgets/transaction_list_container.dart';
class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with
        BasePageMixin<TransactionsPage, TransactionsPagePresenter>,
        AutomaticKeepAliveClientMixin<TransactionsPage>
    implements TransactionsIMvpView {
  List<TransactionViewModel> _transactions = List<TransactionViewModel>();
  LinkedAccountViewModel _linkedAccountViewModel = LinkedAccountViewModel();
  var accountSelectionListener = QpayTransactionSelectorAccountSelectionListener();
  String _selectIntent;


  @override
  void initState() {
    accountSelectionListener.addListener(_onAccountSelected);
    super.initState();
  }
  @override
  void dispose() {
    accountSelectionListener.removeListener(_onAccountSelected);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: GestureDetector(
                child: AccountSelector("Cards", _linkedAccountViewModel,isSource: true,),
                onTap: () {
                  _selectIntent = "linkedAccount";
                  _selectLinkedAccount();
                },
              ),
            ),
            Gaps.vGap8,
            Expanded(
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
                                text:  AppLocalizations.of(context).qPayTxn,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                       TransactionListContainer(context,_transactions),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  TransactionsPagePresenter createPresenter() {
    return TransactionsPagePresenter();
  }

  @override
  void setTransactions(List<TransactionViewModel> transactions) {
    if(mounted) {
      setState(() {
        _transactions = transactions;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;


  void _onAccountSelected() async{
    var account = accountSelectionListener.selectedAccount;
    if (mounted && account != null) {
      setState(() {
        if (_selectIntent == "linkedAccount") {
          _linkedAccountViewModel = accountSelectionListener.selectedAccount;
        }
      });
      await presenter.loadTransactions(_linkedAccountViewModel.id,1);
    }
  }
  void _selectLinkedAccount() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: false,
        builder: (_) => CardsSelectorPage(Constant.qpayTransactionHistoryAccountSelector));
  }

  @override
  void setAccounts(List<LinkedAccountViewModel> accounts) {
    // setState(() {
    //   _linkedAccountViewModel = accounts[0];
    //   // _dropdownMenuItems = buildDropdownAccountItems(accounts);
    //   presenter.loadTransactions(_linkedAccountViewModel.accountId,1);
    //   presenter.accountStatement(_linkedAccountViewModel.accountId);
    // });
  }
}

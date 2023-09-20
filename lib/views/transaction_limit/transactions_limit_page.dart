
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/transaction_limit_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/home_router.dart';
import 'package:qpay/views/transaction_limit/transaction_limit_iview.dart';
import 'package:qpay/views/transaction_limit/transactions_limit_page_presenter.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/daily_limit_container.dart';
import 'package:qpay/widgets/monthly_limit_container.dart';
import 'package:qpay/widgets/txn_range_container.dart';

class TransactionsLimitPage extends StatefulWidget {
  @override
  _TransactionsLimitPageState createState() => _TransactionsLimitPageState();
}

class _TransactionsLimitPageState extends State<TransactionsLimitPage>
    with
        BasePageMixin<TransactionsLimitPage, TransactionsLimitPagePresenter>,
        AutomaticKeepAliveClientMixin<TransactionsLimitPage>
    implements TransactionsLimitIMvpView {
 List<TransactionLimitViewModel> _transactionLimitDailyViewModel = <TransactionLimitViewModel>[];
 List<TransactionLimitViewModel> _transactionLimitMonthlyViewModel = <TransactionLimitViewModel>[];
 List<TransactionLimitViewModel> _transactionLimitRangeViewModel = <TransactionLimitViewModel>[];

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
       appBar: MyAppBar(
         centerTitle: 'Transaction Limit',
       ),
       body: DefaultTabController(
         length: 3,
         child: SafeArea(
           child: Scaffold(
               appBar: AppBar(
                 automaticallyImplyLeading: false,
                 flexibleSpace: Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     TabBar(
                       labelColor: Colours.app_main,
                       unselectedLabelColor: Colours.text,
                       tabs: [
                         Tab(
                           text: AppLocalizations.of(context).dailyLimit,
                         ),
                         Tab(
                           text: AppLocalizations.of(context).monthlyLimit,
                         ),
                         Tab(
                           text: AppLocalizations.of(context).txnRange,
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
               body: TabBarView(children: [
                 DailyLimitContainer(context,_transactionLimitDailyViewModel),
                 MonthlyLimitContainer(context,_transactionLimitMonthlyViewModel),
                 TransactionRangeContainer(context,_transactionLimitRangeViewModel),
               ])),
         ),
       ),
     ),
   );
  }


  @override
  TransactionsLimitPagePresenter createPresenter() {
    return TransactionsLimitPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void setTransactionsLimit(List<TransactionLimitViewModel> transactionsLimit) {
    if(mounted) {
      setState(() {
        _transactionLimitDailyViewModel =
            transactionsLimit.where((element) => element.daily.amount.current !=
                null).toList();
        _transactionLimitMonthlyViewModel =
            transactionsLimit.where((element) => element.monthly.amount
                .current != null).toList();
        _transactionLimitRangeViewModel =
            transactionsLimit.where((element) => element.amountRange.max !=
                null).toList();
      });
    }
  }
}

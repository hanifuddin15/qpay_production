import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:qpay/routers/router_init.dart';
import 'package:qpay/views/home/accounts/account_balance/account_balance_page.dart';
import 'package:qpay/views/home/accounts/account_detail/account_detail_page.dart';
import 'package:qpay/views/home/accounts/account_detail/check_emi/check_emi_detail_page.dart';
import 'package:qpay/views/home/accounts/account_emi/account_emi_page.dart';
import 'package:qpay/views/home/accounts/account_statement/account_statement_page.dart';
import 'package:qpay/views/home/accounts/account_transaction_quota/account_transaction_quota_page.dart';

class AccountRouters implements IRouterProvider{
  static String accountBalance = 'account/accountBalance';
  static String accountStatement = 'account/accountStatement';
  static String accountDetail = 'account/accountDetail';
  static String accountEmi = 'account/accountEmi';
  static String accountEmiDetail = 'account/accountEmiDetail';
  static String accountTxnQuota='account/accountTxnQuota';
  @override
  void initRouter(FluroRouter router) {
    router.define(accountBalance,
        handler: Handler(handlerFunc: (_, __) => AccountBalancePage()));
    router.define(accountStatement,
        handler: Handler(handlerFunc: (_, __) => AccountStatementPage()));
    router.define(accountDetail,
        handler: Handler(handlerFunc: (_, __) => AccountDetailPage()));
    router.define(accountEmi,
        handler: Handler(handlerFunc: (_, __) => AccountEmiPage()));
    router.define(accountTxnQuota,
        handler: Handler(handlerFunc: (_, __) => AccountTransactionQuotaPage()));
    router.define(accountEmiDetail,
        handler: Handler(handlerFunc: (_, __) => CheckEMIDetailPage()));
  }

}
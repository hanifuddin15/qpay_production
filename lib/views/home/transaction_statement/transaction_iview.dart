import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/account_statement_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';

abstract class TransactionsIMvpView implements IMvpView {
  void setTransactions(List<TransactionViewModel> transactions);
  void setAccounts(List<LinkedAccountViewModel> accounts);


}
import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/transaction_limit_vm.dart';

abstract class TransactionsLimitIMvpView implements IMvpView {
  void setTransactionsLimit(List<TransactionLimitViewModel> transactionsLimit);
}
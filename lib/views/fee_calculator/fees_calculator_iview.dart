import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';

abstract class FeesCalculatorIMvpView implements IMvpView {
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel);
}
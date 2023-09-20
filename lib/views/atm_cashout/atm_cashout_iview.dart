import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';

abstract class AtmCashOutIMvpView implements IMvpView {
  void setTokens(List<CashOutTokenViewModel> tokens);
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel);
}
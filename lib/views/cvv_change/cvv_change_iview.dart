import '../../mvp/mvps.dart';
import '../../net/contract/transactions_category_vm.dart';

abstract class Cvv2ChangeIMvpView extends IMvpView{
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel);
}
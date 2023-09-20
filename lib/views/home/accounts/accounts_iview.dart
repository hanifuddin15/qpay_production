import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';

abstract class AccountsIMvpView implements IMvpView {
  void setAccounts(List<LinkedAccountViewModel> accounts);

}
import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';

abstract class AccountBalanceIMvpView implements IMvpView {
  void setAccountBalance(List<AccountBalanceViewModel> accountBalance);
}
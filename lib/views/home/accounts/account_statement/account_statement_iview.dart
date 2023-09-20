import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/account_statement_vm.dart';

abstract class AccountStatementIMvpView implements IMvpView {
  void setAccountStatement(List<AccountStatementViewModel> accountStatement);
}
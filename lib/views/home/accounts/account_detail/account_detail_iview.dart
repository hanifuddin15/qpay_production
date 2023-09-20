import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/account_detail_vm.dart';

abstract class AccountDetailIMvpView implements IMvpView {
  void setAccountDetail(AccountDetailViewModel accountDetail);
}
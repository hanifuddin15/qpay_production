
import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/bank_vm.dart';

abstract class LinkAccountIMvpView implements IMvpView {

  void setBankList(List<BankViewModel> bankList);
  String getAccountLinkType();

}

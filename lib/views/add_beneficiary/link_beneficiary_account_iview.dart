
import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/bank_vm.dart';

abstract class LinkBeneficiaryAccountIMvpView implements IMvpView {

  void setBankAccounts(List<BankViewModel> bankList);
  String getAccountBeneficiaryType();

}

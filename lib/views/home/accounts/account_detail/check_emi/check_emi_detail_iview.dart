import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/account_emi_detail_vm.dart';

abstract class CheckEMIDetailIMvpView implements IMvpView{
  void setEMIDetailsList(List<AccountEMIDetailViewModel> accountEMIDetail);
}
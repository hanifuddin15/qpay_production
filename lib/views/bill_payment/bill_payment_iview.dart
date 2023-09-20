import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/bill_vendor_category_vm.dart';

abstract class BillPaymentIMvpView implements IMvpView {
  void setVendorCategoryList(List<BillVendorCategoryViewModel> vendorCategoryList);
}
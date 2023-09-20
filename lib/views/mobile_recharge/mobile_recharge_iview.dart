import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';

abstract class MobileRechargeIMvpView implements IMvpView {
  void setVendorList(List<BillVendorViewModel> vendorList);
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel);
}
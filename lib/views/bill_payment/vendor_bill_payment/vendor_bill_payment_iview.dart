import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/bill_vendor_params_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';

abstract class VendorBillPaymentIMvpView implements IMvpView {
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel);
  void setVendorParams(BillVendorParamsViewModel billVendorParamsViewModel);
}
import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/scanned_qr_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';

abstract class ScanQrCodeIMvpView implements IMvpView{
  void setData(ScannedQrViewModel model);
  void setTransactionsCategory(List<TransactionCategoryViewModel> transactionCategoryViewModel);
}
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/bill_vendor_category_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/views/bill_payment/bill_payment_iview.dart';

class BillPaymentPresenter  extends BasePagePresenter<BillPaymentIMvpView>{
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        vendorListLoad();
      } catch (e) {
        view.showErrorDialog('Failed to get response!');
        view.closeProgress();
      }
    });
  }
  vendorListLoad() async{
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.vendorCategory,
      onSuccess: (data) {
        var items = data["body"] as List;
        var vendorCategoryList = items
            .map((value)=> BillVendorCategoryViewModel.fromJson(value))
            .toList();
        view.setVendorCategoryList(vendorCategoryList);
      },
    );
  }
}
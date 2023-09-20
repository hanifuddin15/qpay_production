import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/faq_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/views/faq/faq_iview.dart';

class FAQPresenter extends BasePagePresenter<FAQIMvpView>{
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadFAQs();
    });
  }
  Future<List<FAQViewModel>> loadFAQs() async{
    try {
      await asyncRequestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.faqList,
        onSuccess: (data) {
          var items = data["body"] as List;
          var faqs = items
              .map((value) => FAQViewModel.fromJson(value))
              .toList();
          view.setFAQ(faqs);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
  }
}
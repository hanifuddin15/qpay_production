import 'package:qpay/mvp/mvps.dart';
import 'package:qpay/net/contract/faq_vm.dart';

abstract class FAQIMvpView implements IMvpView {
  void setFAQ(List<FAQViewModel> faqs);
}
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/views/shared/webview_gateway_iview.dart';

import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';

class WebViewGatewayPresenter
    extends BasePagePresenter<WebViewGatewayIMvpView> {

  Future<TransactionViewModel> getTransactionById(String txnId) async{
    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.getTransactionById(txnId),
        onSuccess: (data) {
          var responseJson = data["body"]["transaction"];
          response = TransactionViewModel.fromJson(responseJson);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

}

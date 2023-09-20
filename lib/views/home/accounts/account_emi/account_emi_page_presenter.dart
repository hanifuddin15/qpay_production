import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/emi_and_tq_response_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/views/home/accounts/account_emi/account_emi_iview.dart';

class AccountEMIPagePresenter extends BasePagePresenter<AccountEMIIMvpView>{
  Future<EmiAndTqResponseViewModel> emiRequest(String transactionId, int cardId,
      String amount,String transactionCode, String approvalCode,int numOfInstallemnt ) async {
    FormData formData = FormData.fromMap({
      'TransactionId': transactionId,
      'CardId': cardId,
      'Amount':amount,
      'TransactionCode':transactionCode,
      'ApprovalCode': approvalCode,
      'NumberOfInstallments':numOfInstallemnt,
    });

    EmiAndTqResponseViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.emiRequest,
        params: formData,
        onSuccess: (data) {
          var responseJson = data["body"];
          response = EmiAndTqResponseViewModel.fromJson(responseJson);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
}
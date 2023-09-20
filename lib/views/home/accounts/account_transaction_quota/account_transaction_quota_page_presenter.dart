import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/card_status_vm.dart';
import 'package:qpay/net/contract/emi_and_tq_response_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_quota_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/providers/account_selection_listener.dart';

import 'account_transaction_quota_iview.dart';

class AccountTransactionQuotaPagePresenter extends BasePagePresenter<AccountTransactionQuotaIMvpView>{
  LinkedAccountViewModel accountViewModel = AccountSelectionListener().selectedAccount;
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     tqEnquiry(accountViewModel.id);
  //   });
  // }

  Future<List<TransactionQuotaViewModel>> tqEnquiry( int cardId) async {

    List<TransactionQuotaViewModel> response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.tqRequest(cardId),
        onSuccess: (data) {
          var responseJson = data["body"]["data"] as List;
          response = responseJson.map((e) => TransactionQuotaViewModel.fromJson(e)).toList();
          // view.setTransactionQuota(response);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<ApiBasicViewModel> tqRequest( int cardId,String quotaType, bool isEnable) async {
    FormData formData = FormData.fromMap({
      'QuotaType':quotaType,
      'IsEnabled': isEnable,
    });

    ApiBasicViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.tqRequest(cardId),
        params: formData,
        onSuccess: (data) {
          response = ApiBasicViewModel.fromJson(data);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<CardStatusViewModel> getStatus(int accountId) async {
    CardStatusViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.checkStatus(accountId),
        onSuccess: (data) {
          var apiResult =  Result.fromJson(data);
          if(apiResult.isSuccess) {
            response = CardStatusViewModel.fromJson(apiResult.body);
          }else{
            view.showErrorDialog('Failed to get response!');
            view.closeProgress();
          }
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
}
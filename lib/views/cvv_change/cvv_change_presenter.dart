import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/mvp/base_page_presenter.dart';

import '../../net/contract/transaction_fee_vm.dart';
import '../../net/contract/transaction_vm.dart';
import '../../net/contract/transactions_category_vm.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import 'cvv_change_iview.dart';

class Cvv2ChangePresenter extends BasePagePresenter<Cvv2ChangeIMvpView>{
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      transactionLoad();
    });
  }

  transactionLoad() async {
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.transactionCategory,
      onSuccess: (data) {
        var items = data["body"] as List;
        var categoty = items
            .map((value) => TransactionCategoryViewModel.fromJson(value))
            .toList();
        view.setTransactionsCategory(categoty);
      },
    );
  }

  Future<TransactionViewModel> cvvChangeTransfer(int debitAccountId,
      String purpose,String cvv,String newCvv) async {
    FormData formData = FormData.fromMap({
      'DebitAccountId': debitAccountId,
      'SecurityCode' : cvv,
      'Remarks' : purpose,
      'NewCvvCode':newCvv,
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.cvvChangePayment,
        params: formData,
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

  Future<TransactionViewModel> confirmTransaction(String transactionId, String pin) async{
    FormData formData = FormData.fromMap({
      'TransactionId': transactionId,
      'Otp': pin,
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.cvvChangePaymentConfirm,
        params: formData,
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

  Future<List<TransactionFeeViewModel>> transactionFeeCalculate(String id, double amount) async{
    final Map<String, dynamic> queryParams = {
      'PolicyId':id,
      'Amount': amount,
    };
    List<TransactionFeeViewModel> response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.transactionFees,
        queryParameters: queryParams,
        onSuccess: (data) {
          var items = data["body"] as List;
          var responseList = items
              .map((value)=> TransactionFeeViewModel.fromJson(value))
              .toList();
          response = responseList;

        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
}
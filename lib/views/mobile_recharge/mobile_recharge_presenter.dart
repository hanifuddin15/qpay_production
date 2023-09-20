import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/bill_vendor_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/views/mobile_recharge/mobile_recharge_iview.dart';

class MobileRechargePresenter
    extends BasePagePresenter<MobileRechargeIMvpView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        vendorListLoad();
        transactionLoad();
      } catch (e) {
        view.showErrorDialog('Failed to get response!');
        view.closeProgress();
      }
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
  final Map<String, dynamic> queryParams = {
    'Type':'mobile',
  };
  vendorListLoad() async{
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.vendorList,
      queryParameters: queryParams,
      onSuccess: (data) {
        var items = data["body"] as List;
        var vendorList = items
            .map((value)=> BillVendorViewModel.fromJson(value))
            .toList();
        view.setVendorList(vendorList);
      },
    );

  }

  Future<TransactionViewModel> mobileRecharge(
      double amount,
      int mobileOperatorId,
      int connectionId,
      int accountId,
      String phone,String purpose,String cvv) async {
    FormData formData = FormData.fromMap({
      'Amount': amount,
      'Credit.VendorId': mobileOperatorId,
      'Credit.ConnectionId': connectionId,
      'DebitAccountId': accountId,
      'Credit.MobileNumber': phone,
      'Remarks' : purpose,
      'SecurityCode' : cvv
    });
    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.mobileRecharge,
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

  Future<TransactionViewModel> confirmTransaction(
      String transactionId, String otp) async {
    FormData formData = FormData.fromMap({
      'TransactionId': transactionId,
      'Otp': otp,
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.mobileRechargeConfirm,
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

  Future<List<AccountBalanceViewModel>> accountBalance (int accountId) async {
    FormData formData = FormData.fromMap({
      'AccountId': accountId,
    });
    List<AccountBalanceViewModel> response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.accountBalance,
        params: formData,
        onSuccess: (data) {
          var responseJson = data["body"]['data']['currencyBalances'] as List;
          response = responseJson.map((e) => AccountBalanceViewModel.fromJson(e)).toList();
        },
      );
    }catch(e){
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
}

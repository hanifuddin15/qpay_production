import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'card_bill_payment_iview.dart';

class CardBillPaymentPresenter
    extends BasePagePresenter<CardBillPaymentIMvpView>{

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
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

  Future<TransactionViewModel> creditCardBillPayment(double amount, int debitAccountId, int creditCardNumber, bool type,String purpose,String cvv) async {
    FormData formData = FormData.fromMap({
      'Amount': amount,
      'DebitAccountId': debitAccountId,
      'CreditAccountId': creditCardNumber,
      'IsPersonal': type,
      'Remarks' : purpose,
      'SecurityCode' : cvv
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.cardBill,
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
        url: ApiEndpoint.fundTransferConfirm,
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
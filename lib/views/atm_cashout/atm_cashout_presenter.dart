import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/cash_out_token_model.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/providers/cash_out_token_provide.dart';
import 'package:qpay/views/atm_cashout/atm_cashout_iview.dart';

class AtmCashOutPresenter extends BasePagePresenter<AtmCashOutIMvpView> {
  final bool loadOnInit;

  AtmCashOutPresenter(this.loadOnInit);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (loadOnInit){ await loadCashOutTokens();}
      transactionLoad();
    });
  }

    Future<void> loadCashOutTokens() async{
    try {
       await asyncRequestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.myCashOutTokens,
        onSuccess: (data) {
          var items = data["body"] as List;
          var tokens = items
              .map((value) => CashOutTokenViewModel.fromJson(value))
              .toList();
          CashOutTokenProvider().setCashOutToken(tokens);
          view.setTokens(tokens);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
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

  createCashOutToken(int amount, int debitAccountId, String purpose,String cvv) async {
    FormData formData = FormData.fromMap({
      'Amount': amount,
      'DebitAccountId': debitAccountId,
      'Remarks' : purpose,
      'SecurityCode' : cvv
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.atmCashOut,
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

  confirmTransaction(String transactionId, String pin) async{
    FormData formData = FormData.fromMap({
      'TransactionId': transactionId,
      'Otp': pin,
    });

    TransactionViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.atmCashOutConfirm,
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

 extendToken(String transactionId) async{
    FormData formData = FormData.fromMap({
      'TransactionId': transactionId,
    });

    ApiBasicViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.put,
        url: ApiEndpoint.atmCashOut,
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

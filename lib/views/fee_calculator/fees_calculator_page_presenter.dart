import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/views/fee_calculator/fees_calculator_iview.dart';

class FeesCalculatorPagePresenter extends BasePagePresenter<FeesCalculatorIMvpView>{
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var storedCategory = CachedTransactionsCategory().categoryViewModel;
      if  (storedCategory !=null && storedCategory.isNotEmpty) {
        view.setTransactionsCategory(storedCategory);
        return;
      }
      try {
        transactionLoad();
      } catch (e) {
        view.showErrorDialog('Failed to get response!');
        view.closeProgress();
      }
    });
  }

  transactionLoad() async{
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.transactionCategory,
      onSuccess: (data) {
        var items = data["body"] as List;
        var categoty = items
            .map((value)=> TransactionCategoryViewModel.fromJson(value))
            .toList();
        CachedTransactionsCategory().set(categoty);
        view.setTransactionsCategory(categoty);
      },
    );
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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_statement_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_fee_vm.dart';
import 'package:qpay/net/contract/transaction_limit_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/contract/transactions_category_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/views/home/transaction_statement/transaction_iview.dart';
import 'package:qpay/views/transaction_limit/transaction_limit_iview.dart';

class TransactionsLimitPagePresenter
    extends BasePagePresenter<TransactionsLimitIMvpView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        listLoad();
      } catch (e) {
        view.showErrorDialog('Failed to get response!');
        view.closeProgress();
      }
    });
  }

  listLoad() async{
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.transactionLimit,
      onSuccess: (data) {
        var items = data["body"] as List;
        var limits = items
        .map((value)=> TransactionLimitViewModel.fromJson(value))
        .toList();
        // CachedTransactionsLimit().set(limits);
        view.setTransactionsLimit(limits);
      },
    );
  }
}



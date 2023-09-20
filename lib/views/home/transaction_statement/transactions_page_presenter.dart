import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_statement_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/transaction_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/views/home/transaction_statement/transaction_iview.dart';

class TransactionsPagePresenter
    extends BasePagePresenter<TransactionsIMvpView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // loadTransactions(1);
      var storedList = CachedAllLinkedAccounts().accounts;

      if (storedList != null && storedList.isNotEmpty) {
        view.setAccounts(storedList);
        return;
      }
      try {
        listLoad();
      } catch (e) {
        view.showErrorDialog('Failed to get response!');
        view.closeProgress();
      }
    });
  }

  listLoad() {
    asyncRequestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.linkedAccounts,
      onSuccess: (data) {
        var items = data["body"] as List;
        var accounts = items
            .map((value) => LinkedAccountViewModel.fromJson(value))
            .toList();
        CachedAllLinkedAccounts().set(accounts);
        view.setAccounts(accounts);
      },
    );
  }

   loadTransactions (int accountId,int pageNumber, {int pageSize = 50}) async {
    final Map<String, dynamic> queryParams = {
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };

    try {
     await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.myTransactions(accountId),
        queryParameters: queryParams,
        onSuccess: (data) {
          var items = data["body"] as List;
          var transactions = items
              .map((value) => TransactionViewModel.fromJson(value))
              .toList();
          view.setTransactions(transactions);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
  }
}

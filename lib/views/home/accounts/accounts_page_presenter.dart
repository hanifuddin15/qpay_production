import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/views/home/accounts/accounts_iview.dart';

class AccountsPagePresenter extends BasePagePresenter<AccountsIMvpView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  Future<ApiBasicViewModel> unlinkAccount(
      LinkedAccountViewModel account) async {
    CachedAllLinkedAccounts().clear();
      return await unlinkAllAccount(account.ownershipType, account.id);
  }

  Future<ApiBasicViewModel> unlinkAllAccount(String ownerShipType ,int accountId) async {

    ApiBasicViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.delete,
        url: ownerShipType == "Personal"? ApiEndpoint.accountUnLink(accountId) : ApiEndpoint.beneficiaryUnLink(accountId),
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


}


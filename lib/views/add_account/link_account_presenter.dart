import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_linked_vm.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/views/add_account/link_account_iview.dart';

class LinkAccountPresenter extends BasePagePresenter<LinkAccountIMvpView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var linkType = view.getAccountLinkType();
      var storedList = CachedBanks().getBanks(linkType);
      if (storedList != null && storedList.isNotEmpty) {
        var bankList = storedList;
        view.setBankList(bankList);
        return;
      }
      final Map<String, dynamic> queryParams = {
        'type': linkType,
      };
      try {
        asyncRequestNetwork<Map<String, dynamic>>(
          Method.get,
          url: ApiEndpoint.bankList,
          queryParameters: queryParams,
          onSuccess: (data) {
            var items = data["body"] as List;
            var bankList =
                items.map((value) => BankViewModel.fromJson(value)).toList();
            CachedBanks().set(bankList, linkType);
            view.setBankList(bankList);
          },
        );
      } catch (e) {
        view.showErrorDialog('Failed to get response!');
        view.closeProgress();
      }
    });
  }

  var _cache = CachedAllLinkedAccounts();

  Future<AccountLinkedViewModel> linkCard(
      String cardNumber, int expireMonth, int expireYear) async {
    AccountLinkedViewModel response;
    try {
      FormData formData = FormData.fromMap({
        'CardNumber': cardNumber,
        'ExpireMonth': expireMonth,
        'ExpireYear': expireYear,
      });
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.cardLink,
        params: formData,
        onSuccess: (data) {
          var responseJson = data['body'];
          response = AccountLinkedViewModel.fromJson(responseJson);
          _cache.clear();
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  /*Future<AccountLinkedViewModel> linkBankAccount(
      String bankId, String accountNumber) async {
    AccountLinkedViewModel response;
    try {
      FormData formData = FormData.fromMap({
        'BankId': bankId,
        'AccountNumber': accountNumber,
      });
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.bankAccountLink,
        params: formData,
        onSuccess: (data) {
          var responseJson = data['body']['accountLink'];
          response = AccountLinkedViewModel.fromJson(responseJson);
          _cache.clear();
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }*/

  Future<ApiBasicViewModel> confirmCardLink(
      String linkId, String pin) async {
    ApiBasicViewModel response;
    try {
      FormData formData = FormData.fromMap({
        'TrackingId': linkId,
        'Otp': pin,
      });
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.cardLinkVerify,
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
}

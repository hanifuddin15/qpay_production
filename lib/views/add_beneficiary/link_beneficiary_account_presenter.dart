import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_linked_vm.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/bank_vm.dart';
import 'package:qpay/net/contract/bkash_beneficiary_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/static_data/cached_data_holder.dart';

import 'link_beneficiary_account_iview.dart';

class LinkBeneficiaryAccountPresenter extends BasePagePresenter<LinkBeneficiaryAccountIMvpView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var beneficiaryType = view.getAccountBeneficiaryType();
      var storedList = CachedBanks().getBanks(beneficiaryType);
      if (storedList != null && storedList.isNotEmpty) {
        var bankList = storedList;
        view.setBankAccounts(bankList);
        return;
      }
     getProvider(beneficiaryType);
    });
  }

  getProvider(String beneficiaryType){
    final Map<String, dynamic> queryParams = {
      'type': beneficiaryType,
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
          CachedBanks().set(bankList, beneficiaryType);
          view.setBankAccounts(bankList);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
  }

  var _cache = CachedAllLinkedAccounts();

  Future<ApiBasicViewModel> beneficiaryAccountOrCard(
      String account, int bankId, String beneficiaryName, String type, String proofToken ) async {
    ApiBasicViewModel response;
    try {
      FormData formData = FormData.fromMap({
        'InstituteId': bankId,
        'Name': beneficiaryName,
        'Type': type,
        'AccountNumber': account,
        'ProofToken': proofToken
      });
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.beneficiaryAdd,
        params: formData,
        onSuccess: (data) {
          response = ApiBasicViewModel.fromJson(data);
          _cache.clear();
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<BkashViewModel> getBkashBeneficiary(String phoneNumber) async {
    final Map<String, dynamic> queryParams = {
      'phoneNumber': phoneNumber,
    };
    BkashViewModel response;
    try {
     await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.beneficiaryAddBkash,
        queryParameters: queryParams,
        onSuccess: (data) {
          var items = data["body"];
          response = BkashViewModel.fromJson(items);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
}

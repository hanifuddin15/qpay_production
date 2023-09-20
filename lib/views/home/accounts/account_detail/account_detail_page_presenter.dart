import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/account_detail_vm.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/card_status_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/contract/reward_point_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/providers/account_selection_listener.dart';

import 'account_detail_iview.dart';

class AccountDetailPagePresenter extends BasePagePresenter<AccountDetailIMvpView>{
LinkedAccountViewModel accountViewModel = AccountSelectionListener().selectedAccount;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountDetail(accountViewModel.id);
    });
  }

    accountDetail (int accountId) async {

      AccountDetailViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.accountDetail(accountId),
        onSuccess: (data) {
          var responseJson = data["body"] ;
          response = AccountDetailViewModel.fromJson(responseJson);
            view.setAccountDetail(response);
        },
      );
    }catch(e){
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

Future<RewardPointViewModel> getReward(int accountId) async {
    RewardPointViewModel response;
  try {
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.checkReward(accountId),
      onSuccess: (data) {
        var apiResult =  Result.fromJson(data);
        if(apiResult.isSuccess) {
          response = RewardPointViewModel.fromJson(apiResult.body);
        }else{
          view.showErrorDialog('Failed to get response!');
          view.closeProgress();
        }
      },
    );
  } catch (e) {
    view.showErrorDialog('Failed to get response!');
    view.closeProgress();
  }
  return response;
}

Future<RewardPointViewModel> getEMIInformation(int accountId) async {
  RewardPointViewModel response;
  try {
    await requestNetwork<Map<String, dynamic>>(
      Method.get,
      url: ApiEndpoint.checkReward(accountId),
      onSuccess: (data) {
        var apiResult =  Result.fromJson(data);
        if(apiResult.isSuccess) {
          response = RewardPointViewModel.fromJson(apiResult.body);
        }else{
          view.showErrorDialog('Failed to get response!');
          view.closeProgress();
        }
      },
    );
  } catch (e) {
    view.showErrorDialog('Failed to get response!');
    view.closeProgress();
  }
  return response;
}

}
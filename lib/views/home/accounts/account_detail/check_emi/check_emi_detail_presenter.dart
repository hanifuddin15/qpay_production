import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_emi_detail_vm.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'check_emi_detail_iview.dart';

class CheckEMIDetailPagePresenter extends BasePagePresenter<CheckEMIDetailIMvpView>{
  LinkedAccountViewModel accountViewModel = AccountSelectionListener().selectedAccount;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkEMIDetail(accountViewModel.id);
    });
  }

  checkEMIDetail (int accountId) async {

    List<AccountEMIDetailViewModel> response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.get,
        url: ApiEndpoint.checkEMIDetail(accountId),
        onSuccess: (data) {
          var apiResult =  Result.fromJson(data);
         if(apiResult.isSuccess) {
           var responseJson = data["body"] as List;
           response = responseJson.map((e) =>AccountEMIDetailViewModel.fromJson(e)).toList();
           view.setEMIDetailsList(response);
         }
        },
      );
    }catch(e){
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

}
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_balance_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/providers/account_selection_listener.dart';
import 'package:qpay/views/home/accounts/account_balance/account_balance_iview.dart';

class AccountBalancePagePresenter extends BasePagePresenter<AccountBalanceIMvpView>{
LinkedAccountViewModel accountViewModel = AccountSelectionListener().selectedAccount;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountBalance(accountViewModel.id);
    });
  }

    accountBalance (int accountId) async {
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
          if(response.isNotEmpty) {
            view.setAccountBalance(response);
          }
          else{
            view.showErrorDialog('No data found!');
            view.closeProgress();
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
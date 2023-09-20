import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/account_statement_vm.dart';
import 'package:qpay/net/contract/linked_account_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/providers/account_selection_listener.dart';

import 'account_statement_iview.dart';

class AccountStatementPagePresenter extends BasePagePresenter<AccountStatementIMvpView>{
LinkedAccountViewModel accountViewModel = StatementAccountSelectionListener().selectedAccount;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountStatement(accountViewModel.id);
    });
  }

    accountStatement (int accountId) async {
      FormData formData = FormData.fromMap({
        'AccountId': accountId,
      });
    List<AccountStatementViewModel> response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.accountStatement,
        params: formData,
        onSuccess: (data) {
          var responseJson = data["body"]['data']['transactions'] as List;
          response = responseJson.map((e) => AccountStatementViewModel.fromJson(e)).toList();
          if(response.isNotEmpty) {
            view.setAccountStatement(response);
          }else{
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
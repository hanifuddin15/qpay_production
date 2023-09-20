import 'package:dio/dio.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/views/reset_password/reset_password_iview.dart';

class ResetPasswordPresenter extends BasePagePresenter<ResetPasswordIMvpView>{
  Future<ApiBasicViewModel> resetPassword(String oldPassword, String newPassword) async{
    FormData formData = FormData.fromMap({
      'Current': oldPassword,
      'New': newPassword,
    });

    ApiBasicViewModel response;
    try {
      await requestNetwork<Map<String, dynamic>>(
        Method.put,
        url: ApiEndpoint.resetPassword,
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
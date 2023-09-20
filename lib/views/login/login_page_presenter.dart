import 'package:dio/dio.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/forget_password_vm.dart';
import 'package:qpay/net/contract/token_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';

import 'login_iview.dart';

class LoginPagePresenter extends BasePagePresenter<LoginIMvpView> {
  static const String _grantType = "password";
  static const String _refreshGrantType = "refresh_token";
  static const String _scope = "offline_access mobile_application";
  static const String _client_id = "qpay_mobile_app";
  static const String client_secret = "qpayapplication007";

  Future<TokenViewModel> userLogin(
      String phone,
      String password,
      String deviceId,
      String deviceName,
      String deviceModel,
      NetErrorCallback onError) async {
    //on status code 451 take to device change screen
    TokenViewModel response;
    try {
      final Map<String, dynamic> formData = {
        'username': phone,
        'password': password,
        'grant_type': _grantType,
        'scope': _scope,
        'device_id': deviceId,
        'client_id': _client_id,
        'client_secret': client_secret,
        'device_name': deviceName,
        'device_model': deviceModel,
      };
      await requestUsingEncryptedNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.token,
          params: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          onSuccess: (data) {
        response = TokenViewModel.fromJson(data);
      }, onError: onError);
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<ApiBasicViewModel> changeDevice(String phone, String otp,
      String deviceId, String deviceName) async {
    ApiBasicViewModel response;
    try {
      FormData formData = FormData.fromMap({
        'PhoneNumber': phone,
        'VerificationCode': otp,
        'DeviceId': deviceId,
        'DeviceName': deviceName,
      });
      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.deviceChange,
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

  Future<TokenViewModel> refreshSession(String refreshToken,
  String deviceId) async{
    TokenViewModel response;
    try {
      final Map<String, dynamic> formData = {
        'grant_type': _refreshGrantType,
        'client_id': _client_id,
        'client_secret': client_secret,
        'refresh_token': refreshToken,
        'device_id': deviceId,
      };
      await requestUsingEncryptedNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.token,
          params: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          onSuccess: (data) {
            response = TokenViewModel.fromJson(data);
          });
    } catch (e) {
      view?.showErrorDialog('Failed to get response!');
      view?.closeProgress();
    }
    return response;
  }

  refreshSessionNoView(String refreshToken) async{
    TokenViewModel response;
    try {
      final Map<String, dynamic> formData = {
        'grant_type': _refreshGrantType,
        'scope': _scope,
        'client_id': _client_id,
        'client_secret': client_secret,
        'refresh_token': refreshToken,
      };
      await requestUsingEncryptedNetwork<Map<String, dynamic>>(Method.post,
          isShow: false,
          isClose: false,
          url: ApiEndpoint.token,
          params: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          onSuccess: (data) {
            response = TokenViewModel.fromJson(data);
          });
    } catch (e) {
      view?.showErrorDialog('Failed to get response!');
      view?.closeProgress();
    }
    return response;
  }

  forgetPassword(String email, String deviceId) async{
    ForgetPasswordViewModel response;
    try {
      final Map<String, dynamic> formData = {
        'Email': email,
        'DeviceId': deviceId,
      };
      await requestUsingEncryptedNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.forgetPassword,
          params: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          onSuccess: (data) {
        var responseJson = data["body"];
            response = ForgetPasswordViewModel.fromJson(responseJson);
          });
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  forgetPasswordConfirm(String token,String password,String phone, String deviceId) async{
    ApiBasicViewModel response;
    try {
      final Map<String, dynamic> formData = {

        'Token':token,
        'PhoneNumber':phone,
        'NewPassword': password,
        'DeviceId': deviceId,
      };
      await requestUsingEncryptedNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.forgetPasswordConfirm,
          params: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          onSuccess: (data) {
            response = ApiBasicViewModel.fromJson(data);
          });
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
}

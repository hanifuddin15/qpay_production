import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/nid_parse_information_dto.dart';
import 'package:qpay/net/contract/nid_update_dto.dart';
import 'package:qpay/net/contract/profile_vm.dart';
import 'package:qpay/net/contract/user_register_dto.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/verification_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/providers/nid_update_status_provider.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/views/registration/register_iview.dart';

class RegisterPagePresenter extends BasePagePresenter<RegisterIMvpView> {
  Future<ProofViewModel> requestPhoneVerificationCode(
      String mobileNumber, String deviceId) async {
    ProofResponseViewModel response;
    try {
      final FormData formData = FormData.fromMap({
        'Id': mobileNumber,
        'DeviceId': deviceId
      });
      await requestNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.phoneVerificationCodeRequest, params: formData, onSuccess: (data) {
            var apiResult = Result.fromJson(data);
            if(apiResult.isSuccess) {
              response = ProofResponseViewModel.fromJson(apiResult.body);
            }else{
              view.showErrorDialog(apiResult.errorMessage);
              view.closeProgress();
            }
      });
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response?.proofViewModel;
  }

  Future<ProofViewModel> submitPhoneVerification(
      String mobileNumber, String deviceId, String vPhoneCode) async {
    ProofResponseViewModel response;
    try {
      final FormData formData = FormData.fromMap({
        'Id': mobileNumber,
        'DeviceId': deviceId,
        'VerificationCode':vPhoneCode
      });
      await requestNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.phoneVerificationSubmit,
          params: formData,
          onSuccess: (data) {
            var apiResult = Result.fromJson(data);
            if(apiResult.isSuccess) {
              response = ProofResponseViewModel.fromJson(apiResult.body);
            }else{
              view.showErrorDialog(apiResult.errorMessage);
              view.closeProgress();
            }
          });
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response.proofViewModel;
  }

  Future<ProofViewModel> requestEmailVerificationCode(
      String emailAddress, String deviceId) async {
    ProofResponseViewModel response;
    try {
      final FormData formData = FormData.fromMap({
        'Id': emailAddress,
        'DeviceId': deviceId
      });
      await requestNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.emailVerificationCodeRequest, params: formData, onSuccess: (data) {
            var apiResult = Result.fromJson(data);
            if(apiResult.isSuccess) {
              response = ProofResponseViewModel.fromJson(apiResult.body);
            }else{
              view.showErrorDialog(apiResult.errorMessage);
              view.closeProgress();
            }
          });
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response.proofViewModel;
  }

  Future<ProofViewModel> submitEmailVerification(
      String emailAddress, String deviceId, String vEmailCode) async {
    ProofResponseViewModel response;
    try {
      final FormData formData = FormData.fromMap({
        'Id': emailAddress,
        'DeviceId': deviceId,
        'VerificationCode':vEmailCode
      });
      await requestNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.emailVerificationSubmit,
          params: formData,
          onSuccess: (data) {
            var apiResult = Result.fromJson(data);
            if(apiResult.isSuccess) {
              response = ProofResponseViewModel.fromJson(apiResult.body);
            }else{
              view.showErrorDialog(apiResult.errorMessage);
              view.closeProgress();
            }
          });
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response.proofViewModel;
  }

  Future<ApiBasicViewModel> registerUser(UserRegisterDto data) async {
    ApiBasicViewModel response;
    try {

      final FormData formData = FormData.fromMap({
        'PhoneNumber': data.mobileNumber,
        'PhoneNumberVerificationProofToken': StaticKeyValueStore().get(Constant.phoneVerificationToken),
        'EmailAddress': null,
        'EmailAddressVerificationProofToken': null,
        'NameEnglish': null,
        'Gender':null,
        'DateOfBirth': "01-01-2001",
        'UserImage': null,
        'NidNumber': null,
        'Password': data.password,
        'DeviceId': data.deviceId,
        'DeviceName': data.deviceName,

      });
      await requestNetwork<Map<String, dynamic>>(Method.post,
          url: ApiEndpoint.register, params: formData, onSuccess: (data) {
        response = ApiBasicViewModel.fromJson(data);
      });
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

  Future<ApiBasicViewModel> profileUpdate(UserRegisterDto data,NidParseInformationDto nidParseInformationDto) async {
    ApiBasicViewModel response;
    try {
      var profileImageName =
      data.profileImage.substring(data.profileImage.lastIndexOf('/') + 1);
      final FormData formData = FormData.fromMap({
        'FullName': nidParseInformationDto.nameEnglish,
        'Gender':nidParseInformationDto.gender,
        'DateOfBirth': nidParseInformationDto.dateOfBirth,
        'NidNumber': nidParseInformationDto.nidNumber,
        'UserImage': await MultipartFile.fromFile(data.profileImage,
            filename: profileImageName),

      });
      await requestNetwork<Map<String, dynamic>>(Method.put,
          url: ApiEndpoint.profileUpdate, params: formData, onSuccess: (data) {
            response = ApiBasicViewModel.fromJson(data);
          });
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }

}

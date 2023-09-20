import 'package:dio/dio.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/views/home/profile/profile_veiw_iview.dart';

class ProfileViewPresenter extends BasePagePresenter<ProfileViewIMvpView>{

  Future<String> uploadProfileImage(String profileImage) async {
    String response;
    try {
      var profileImageName = profileImage.substring(profileImage.lastIndexOf('/') + 1);

      FormData formData = FormData.fromMap({
        'ProfileImage': await MultipartFile.fromFile(profileImage,
            filename: profileImageName),
      });

      await requestNetwork<Map<String, dynamic>>(
        Method.put,
        url: ApiEndpoint.profileImageUpdate,
        params: formData,
        onSuccess: (data) {
          var responseJson = Result.fromJson(data);
          if(responseJson.isSuccess){
            response = responseJson.body;
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
import 'package:dio/dio.dart';
import 'package:qpay/mvp/base_page_presenter.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/nid_information_parse_vm.dart';
import 'package:qpay/net/contract/nid_update_dto.dart';
import 'package:qpay/net/dio_utils.dart';
import 'package:qpay/net/http_api.dart';
import 'package:qpay/views/nid/nid_iview.dart';

class NidUploadPresenter extends BasePagePresenter<NidIMvpView>{

  Future<NidInformationParseViewModel> uploadNid(NidUpdateDto nidData) async {
    NidInformationParseViewModel response;

    try {
      var nidFrontName = nidData.nidFrontPath
          .substring(nidData.nidFrontPath.lastIndexOf('/') + 1);
      var nidBankName = nidData.nidBackPath
          .substring(nidData.nidBackPath.lastIndexOf('/') + 1);

      FormData formData = FormData.fromMap({
        /*'NidNumber': nidData.nidNumber,*/
        'NidFront': await MultipartFile.fromFile(nidData.nidFrontPath,
            filename: nidFrontName),
        'NidBack': await MultipartFile.fromFile(nidData.nidBackPath,
            filename: nidBankName),
      });

      await requestNetwork<Map<String, dynamic>>(
        Method.post,
        url: ApiEndpoint.nidUpdate,
        params: formData,
        onSuccess: (data) {
          var responseJson = data["body"];
          response = NidInformationParseViewModel.fromJson(responseJson);
        },
      );
    } catch (e) {
      view.showErrorDialog('Failed to get response!');
      view.closeProgress();
    }
    return response;
  }
}
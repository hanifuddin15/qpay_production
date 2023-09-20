class ProfileViewModel {
  String imageUrl;
  String name = "User";
  String phoneNumber;
  String gender;
  String address;
  String emailAddress;
  String nationalIdNumber;
  int defaultPaymentAccount;
  String dateOfBirth;
  String notification;
  List<ProfileErrorViewModel> errors;

  ProfileViewModel.fromJson(Map<String, dynamic> json) {
    var profileJson = json['body'];
    name = _getFromJsonByKey(profileJson, 'name')?.toString();
    imageUrl = _getFromJsonByKey(profileJson, 'imageUrl')?.toString();
    phoneNumber = _getFromJsonByKey(profileJson, 'phoneNumber')?.toString();
    gender = _getFromJsonByKey(profileJson, 'gender')?.toString();
    emailAddress = _getFromJsonByKey(profileJson, 'emailAddress')?.toString();
    address = _getFromJsonByKey(profileJson, 'address')?.toString();
    dateOfBirth = _getFromJsonByKey(profileJson, 'dateOfBirth')?.toString();
    notification = _getFromJsonByKey(profileJson, 'notification')?.toString();
    nationalIdNumber =
        _getFromJsonByKey(profileJson, 'nationalIdNumber')?.toString();
    defaultPaymentAccount = int.parse(
        _getFromJsonByKey(profileJson, 'defaultPaymentAccount')?.toString());

    var items = profileJson["errors"] as List;
    errors =
        items.map((value) => ProfileErrorViewModel.fromJson(value)).toList();
  }

  dynamic _getFromJsonByKey(Map<String, dynamic> json, String key) {
    if (json[key] != null) {
      return json[key];
    }
  }

  ProfileViewModel();
}

class ProfileErrorViewModel {
  int code;
  String property;
  String details;

  ProfileErrorViewModel();

  ProfileErrorViewModel.fromJson(Map<String, dynamic> json) {
    property = json['property']?.toString();
    details = json['details']?.toString();
    code = int.parse(json['code']?.toString());
  }
}

class AccountLinkedViewModel {
  String message;
  String trackingId;
  String accountNumber;
  bool isLinked;

  AccountLinkedViewModel.fromJson(Map<String, dynamic> json) {

    if (json['message'] != null) {
      message = json['message']?.toString();
    }
    if (json['trackingId'] != null) {
      trackingId = json['trackingId']?.toString();
    }
    if (json['isLinked'] != null) {
      isLinked = json['isLinked'].toString().toLowerCase() == 'true';
    }
    if (json['accountNumber'] != null) {
      accountNumber = json['accountNumber'].toString();
    }
  }
}

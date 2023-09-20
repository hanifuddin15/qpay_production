class EmiAndTqResponseViewModel {
  String transactionId;
  String responseMessage;

  EmiAndTqResponseViewModel.fromJson(Map<String, dynamic> json){
    if (json['transactionId'] != null) {
      transactionId = json['transactionId']?.toString();
    }
    if (json['responseMessage'] != null) {
      responseMessage = json['responseMessage']?.toString();
    }
  }
  Map<String, dynamic> toJson() => {
    'transactionId': transactionId,
    'responseMessage': responseMessage
  };
}
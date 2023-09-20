class AccountStatementViewModel{
  String transactionId;
  bool isEmiApplicable ;
  String transactionTime;
  String amount;
  String amountAcct;
  String location;
  String description ;
  String transactionCode;
  String approvalCode;
  String reflection;
  String terminal;




  AccountStatementViewModel.fromJson(Map<String, dynamic> json){
    if (json['transactionId'] != null){
      transactionId = json['transactionId']?.toString();
    }
    if (json['transactionTimeFormatted'] != null){
      transactionTime = json['transactionTimeFormatted']?.toString();
    }
    if (json['amount'] != null){
      amount = json['amount']?.toString();
    }
    if (json['amountAcct'] != null){
      amountAcct = json['amountAcct']?.toString();
    }

    if (json['location'] != null){
      location = json['location']?.toString();
    }
    if (json['description'] != null){
      description = json['description']?.toString();
    }
    if (json['isEmiApplicable'] != null){
      isEmiApplicable = json['isEmiApplicable']?.toString()=='true'? true : false;
    }
    if (json['transactionCode'] != null){
      transactionCode = json['transactionCode']?.toString();
    }
    if (json['approvalCode'] != null){
      approvalCode = json['approvalCode']?.toString();
    }
    if (json['reflection'] != null) {
      reflection = json['reflection']?.toString();
    }
    if (json['terminal'] != null) {
      terminal = json['terminal']?.toString();
    }
  }
  Map<String, dynamic> toJson() =>{
    'transactionId': transactionId,
    'transactionTime':transactionTime,
    'amount':amount,
    'amountAcct':amountAcct,
    'location':location,
    'description':description,
    'isEmiApplicable' : isEmiApplicable,
    'transactionCode':transactionCode,
    'approvalCode':approvalCode,
    'reflection':reflection,
    'terminal':terminal
  };
}

class ValueAddedServiceResponse {
  String errorMessage;
  int code;
  dynamic body;
  bool isSuccess;

  ValueAddedServiceResponse.fromJson(dynamic json){
    body = json['body']['data'];
    errorMessage = json['errorMessage'];
    isSuccess = json['isSuccess']?.toString()?.toLowerCase() == 'true';
  }
}
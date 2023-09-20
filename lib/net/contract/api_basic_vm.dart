class ApiBasicViewModel {
  String errorMessage;
  bool isSuccess;

  ApiBasicViewModel.fromJson(Map<String, dynamic> json) {
    if (json['errorMessage'] != null) {
      errorMessage = json['errorMessage']?.toString();
    }
    if (json['isSuccess'] != null) {
      isSuccess = json['isSuccess']?.toString()?.toLowerCase() == 'true';
    }
  }
}
class Result {
   String errorMessage;
   int code;
   dynamic body;
   bool isSuccess;

   Result.fromJson(dynamic json){
     body = json['body'];
     errorMessage = json['errorMessage'];
     isSuccess = json['isSuccess']?.toString()?.toLowerCase() == 'true';
   }
}

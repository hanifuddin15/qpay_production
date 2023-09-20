class TransactionQuotaViewModel{
  String limitName;
  int status;
  TransactionQuotaViewModel.fromJson(Map<String, dynamic> json){
    if  (json['status'] != null){
      status = (json['status']?.toString()=='true' ? 1 : 0);
    }
    if (json['limitName'] != null) {
      limitName = json['limitName']?.toString();
    }
  }
}
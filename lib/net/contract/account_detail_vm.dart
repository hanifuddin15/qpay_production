class AccountDetailViewModel{
  String nextStatementDate;
  String statementDate;
  String paymentDueDate;
  CurrencyDetailViewModel bdt;
  CurrencyDetailViewModel usd;

  AccountDetailViewModel.fromJson(Map<String, dynamic> json){
    nextStatementDate = json['nextStatementDate'];
    statementDate = json['statementDate'];
    paymentDueDate = json['paymentDueDate'];
    bdt = CurrencyDetailViewModel.fromJson(json['bdt']);
    usd = CurrencyDetailViewModel.fromJson(json['usd']);
  }

}

class CurrencyDetailViewModel{
  String creditLimit;
  String minPayment;
  String outstanding;

  CurrencyDetailViewModel.fromJson(Map<String, dynamic> json){
    creditLimit = json['creditLimit'];
    minPayment = json['minPayment'];
    outstanding = json['outstanding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditLimit'] = this.creditLimit;
    data['minPayment'] = this.minPayment;
    data['outstanding'] = this.outstanding;
    return data;
  }
}
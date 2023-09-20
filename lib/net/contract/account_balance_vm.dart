class AccountBalanceViewModel{
  String accountNumber;
  String lastTransactionTime;
  String currency;
  String holdAmount;
  String balance;

  AccountBalanceViewModel.fromJson(Map<String, dynamic> json){
    if (json['accountNumber'] != null){
      accountNumber = json['accountNumber']?.toString();
    }
    if (json['lastTransactionTime'] != null){
      lastTransactionTime = json['lastTransactionTime']?.toString();
    }
    if (json['currency'] != null){
      currency = json['currency']?.toString();
    }
    if (json['holdAmount'] != null){
      holdAmount = json['holdAmount']?.toString();
    }
    if (json['balance'] != null){
      balance = json['balance']?.toString();
    }
  }
  Map<String, dynamic> toJson() =>{
   'accountNumber': accountNumber,
   'lastTransactionTime':lastTransactionTime,
   'currency':currency,
   'holdAmount':holdAmount,
   'balance':balance
  };
}
class ScannedQrViewModel{
  String retailerName;
  String terminalCity;
  TransactionAmountViewModel transactionAmount;
  TransactionTipsOrConvenienceViewModel transactionTipOrConvenience;
  List<MerchantPansViewModel> merchantPans;

  ScannedQrViewModel.formJson(Map<String, dynamic> json){

    retailerName = json['name']?.toString()??'';

    terminalCity = json['location']?.toString()??'';

    transactionAmount = TransactionAmountViewModel.formJson(json['transactionAmount']);

    transactionTipOrConvenience = TransactionTipsOrConvenienceViewModel.formJson(json['transactionTipOrConvenience']);
    var items = json['merchantPans'] as List;
    merchantPans =
        items.map((value) => MerchantPansViewModel.formJson(value)).toList();
  }
  ScannedQrViewModel();
}

class TransactionAmountViewModel{
  var amount;
  bool isActive;
  TransactionAmountViewModel();
  TransactionAmountViewModel.formJson(Map<String,dynamic> json){
    amount = json['amount']??0.0;
    isActive = json['isActive']??false;
  }
}

class TransactionTipsOrConvenienceViewModel{
  var amount;
  String indicator;
  TransactionTipsOrConvenienceViewModel();
  TransactionTipsOrConvenienceViewModel.formJson(Map<String,dynamic> json){
    amount = json['amount']??0;
    indicator = json['indicator']??'';
  }
}

class MerchantPansViewModel{
  String identifier;
  String index;
  String pan;
  String issuer;
  MerchantPansViewModel();
  MerchantPansViewModel.formJson(Map<String, dynamic> json){
    identifier = json['identifier'].toString()??'';
    index = json['index']?.toString()??'';
    pan = json['pan']?.toString()??'';
    issuer = json['issuer']?.toString()??'';
  }
}

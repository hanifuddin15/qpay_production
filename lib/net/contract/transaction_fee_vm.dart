class TransactionFeeViewModel{
  String fee;
  String vat;
  int vendorId;
  String vendorName;
  bool isOtpRequired;

  TransactionFeeViewModel({this.fee,this.vat, this.vendorId, this.vendorName,this.isOtpRequired});

  TransactionFeeViewModel.fromJson(Map<String, dynamic> json) {
    fee = json['fee'].toString();
    vat = json['vat'].toString();
    vendorId = int.parse(json['vendorId'].toString());
    vendorName = json['vendorName'].toString();
    isOtpRequired = json['isOtpRequired']??true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['vat'] = this.vat;
    data['vendorId'] = this.vendorId;
    data['vendorName'] = this.vendorName;
    data['isOtpRequired'] = this.isOtpRequired;
    return data;
  }
}
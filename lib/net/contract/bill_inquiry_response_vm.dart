class BillInquiryResponseViewModel {
  String referenceId;
  String mobileNumber;
  String typeOfBill;
  double totalBillAmount;
  double  fees;
  List<Value> value;

  BillInquiryResponseViewModel(
      {this.referenceId,
        this.mobileNumber,
        this.typeOfBill,
        this.totalBillAmount,
        this.fees,
        this.value});

  BillInquiryResponseViewModel.fromJson(Map<String, dynamic> json) {
    referenceId = json['referenceId'];
    mobileNumber = json['mobileNumber'];
    typeOfBill = json['typeOfBill'];
    totalBillAmount = double.parse( json['totalBillAmount'].toString()) ?? 0.0 ;
    fees = double.parse(json['fees'].toString()) ?? 0.0 ;
    if (json['value'] != null) {
      value = new List<Value>();
      json['value'].forEach((v) {
        value.add(new Value.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referenceId'] = this.referenceId;
    data['mobileNumber'] = this.mobileNumber;
    data['typeOfBill'] = this.typeOfBill;
    data['totalBillAmount'] = this.totalBillAmount;
    data['fees'] = this.fees;
    if (this.value != null) {
      data['value'] = this.value.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Value {
  String key;
  String value;

  Value({this.key, this.value});

  Value.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
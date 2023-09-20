class AccountEMIDetailViewModel{
  String id;
  String merchantName;
  String createdAt;
  String emiAmount;
  String installmentAmount;
  String totalCycle;
  String unPaidCycle;
  String unPaidAmount;
  String status;

  AccountEMIDetailViewModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    merchantName = json['merchantName'];
    createdAt = json['createdAt'];
    emiAmount = json['emiAmount'];
    installmentAmount = json['installmentAmount'];
    totalCycle = json['totalCycle'];
    unPaidCycle = json['unPaidCycle'];
    unPaidAmount = json['unPaidAmount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantName'] = this.merchantName;
    data['createdAt'] = this.createdAt;
    data['emiAmount'] = this.emiAmount;
    data['installmentAmount'] = this.installmentAmount;
    data['totalCycle'] = this.totalCycle;
    data['unPaidCycle'] = this.unPaidCycle;
    data['unPaidAmount'] = this.unPaidAmount;
    data['status'] = this.status;
    return data;
  }
}

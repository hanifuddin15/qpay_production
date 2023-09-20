
class BillVendorParamsViewModel {
  String id;
  String uniqueId;
  String transactionType;
  int vendorId;
  String imageUrl;
  String domain;
  int connectionId;
  bool isActive;
  VendorParams billNo ;
  VendorParams accountNumber;
  VendorParams mobileNumber;
  VendorParams billingTypes;
  VendorParams billingMonths;
  VendorParams billingYears;
  VendorParams amount;

  BillVendorParamsViewModel(
      {this.id,
        this.uniqueId,
        this.transactionType,
        this.vendorId,
        this.imageUrl,
        this.domain,
        this.connectionId,
        this.isActive,
        this.amount,
        this.billNo,
        this.accountNumber,
        this.mobileNumber,
        this.billingTypes,
        this.billingMonths,
        this.billingYears});

  BillVendorParamsViewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['uniqueId'];
    transactionType = json['transactionType'];
    vendorId = json['vendorId'];
    imageUrl = json['imageUrl'];
    domain = json['domain'];
    connectionId = json['connectionId'];
    isActive = json['isActive'];
    amount = json['amount'] != null
        ? new VendorParams.fromJson(json['amount'])
        : null;
    billNo = json['billNo'] != null
        ? new VendorParams.fromJson(json['billNo'])
        : null;
    accountNumber = json['accountNumber'] != null
        ? new VendorParams.fromJson(json['accountNumber'])
        : null;
    mobileNumber = json['mobileNumber'] != null
        ? new VendorParams.fromJson(json['mobileNumber'])
        : null;
    billingTypes = json['billingTypes'] != null
        ? new VendorParams.fromJson(json['billingTypes'])
        : null;
    billingMonths = json['billingMonths'] != null
        ? new VendorParams.fromJson(json['billingMonths'])
        : null;
    billingYears = json['billingYears'] != null
        ? new VendorParams.fromJson(json['billingYears'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uniqueId'] = this.uniqueId;
    data['transactionType'] = this.transactionType;
    data['vendorId'] = this.vendorId;
    data['imageUrl'] = this.imageUrl;
    data['domain'] = this.domain;
    data['connectionId'] = this.connectionId;
    data['isActive'] = this.isActive;
    if (this.billNo != null) {
      data['billNo'] = this.billNo.toJson();
    }
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    if (this.accountNumber != null) {
      data['accountNumber'] = this.accountNumber.toJson();
    }
    if (this.mobileNumber != null) {
      data['mobileNumber'] = this.mobileNumber.toJson();
    }
    if (this.billingTypes != null) {
      data['billingTypes'] = this.billingTypes.toJson();
    }
    if (this.billingMonths != null) {
      data['billingMonths'] = this.billingMonths.toJson();
    }
    if (this.billingYears != null) {
      data['billingYears'] = this.billingYears.toJson();
    }
    return data;
  }
}

class VendorParams {
  String displayName;
  bool isRequired ;
  bool isActive;
  bool isDropDown;
  List<DropDownData> dropDownData;

  VendorParams(
      {this.displayName,
        this.isRequired,
        this.isActive,
        this.isDropDown,
        this.dropDownData});

  VendorParams.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    isRequired = json['isRequired'];
    isActive = json['isActive'];
    isDropDown = json['isDropDown'];
    if (json['dropDownData'] != null) {
      dropDownData = new List<DropDownData>();
      json['dropDownData'].forEach((v) {
        dropDownData.add(new DropDownData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['isRequired'] = this.isRequired;
    data['isActive'] = this.isActive;
    data['isDropDown'] = this.isDropDown;
    if (this.dropDownData != null) {
      data['dropDownData'] = this.dropDownData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropDownData {
  String key;
  String value;

  DropDownData({this.key, this.value});

  DropDownData.fromJson(Map<String, dynamic> json) {
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
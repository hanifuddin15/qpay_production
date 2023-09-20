class LinkedAccountViewModel {
  String institutionCode;
  String accountNumberMasked;
  String financialAccountType;
  String productType;
  int id;
  String ownershipType;
  String expiryDate;
  String instituteName;
  String accountHolderName;
  String imageUrl;
  String vendor;
  String brand;
  LinkedAccountViewModel({this.accountNumberMasked,this.accountHolderName, this.instituteName, this.productType,this.imageUrl});

  LinkedAccountViewModel.fromJson(Map<String, dynamic> json) {
    if (json['institutionCode'] != null) {
      institutionCode = json['institutionCode']?.toString();
    }
    if (json['accountNumberMasked'] != null) {
      accountNumberMasked = json['accountNumberMasked']?.toString();
    }
    if (json['financialAccountType'] != null) {
      financialAccountType = json['financialAccountType']?.toString();
    }
    if (json['productType'] != null) {
      productType = json['productType']?.toString();
    }
    if (json['id'] != null) {
      id = int.parse(json['id'].toString());
    }
    if(json['ownershipType'] != null){
      ownershipType = json['ownershipType'].toString();
    }
    if (json['expiryDate'] != null){
      expiryDate = json['expiryDate']?.toString();
    }
    if (json['instituteName'] != null) {
      instituteName = json['instituteName']?.toString();
    }
    if (json['accountHolderName'] != null){
      accountHolderName = json['accountHolderName']?.toString();
    }
    if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl']?.toString();
    }
    if (json['vendor'] != null) {
      vendor = json['vendor']?.toString();
    }
    if (json['brand'] != null) {
      brand = json['brand']?.toString();
    }
  }

  Map<String, dynamic> toJson() => {
    'institutionCode':institutionCode,
    'accountNumberMasked': accountNumberMasked,
    'financialAccountType': financialAccountType,
    'productType': productType,
    'id': id,
    'ownershipType':ownershipType,
    'expiryDate': expiryDate,
    'instituteName': instituteName,
    'accountHolderName':accountHolderName,
    'imageUrl': imageUrl,
    'vendor': vendor,
    'brand': brand,
  };

  bool isCard() {
    return productType == 'DebitCard' || productType == 'CreditCard' || productType == 'PrepaidCard' || productType == 'PaymentGateway';
  }
}

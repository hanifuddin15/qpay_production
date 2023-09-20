class BankViewModel {
  String name;
  String imageUrl;
  int id;
  String description;
  String code;
  AllowType allowCard;
  AllowType allowAccount;

  BankViewModel(this.name, this.imageUrl, this.id,this.allowCard,this.allowAccount);

  BankViewModel.fromJson(Map<String, dynamic> json) {
    if (json['name'] != null) {
      name = json['name']?.toString();
    }
    if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl']?.toString();
    }
    if (json['code'] != null) {
      code = json['code']?.toString();
    }
    if (json['id'] != null) {
      id = int.parse(json['id']?.toString());
    }
    if (json['description'] != null) {
      description = json['description'].toString();
    }
    if (json['allowCard'] != null) {
      allowCard = AllowType.fromJson(json['allowCard']);
    }
    if (json['allowAccount'] != null) {
      allowAccount = AllowType.fromJson(json['allowAccount']);
    }

  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
    'code':code,
    'id': id,
    'description': description,
    'allowCard':allowCard,
    'allowAccount':allowAccount,
  };
}

class AllowType{
  bool addLinkAllow;
  bool addBeneficiaryAllow;
  AllowType(this.addLinkAllow,this.addBeneficiaryAllow);

  AllowType.fromJson(Map<String, dynamic> json) {
    if (json['addLinkAllow'] != null) {
      addLinkAllow = json['addLinkAllow'];
    }
    if (json['addBeneficiaryAllow'] != null) {
      addBeneficiaryAllow = json['addBeneficiaryAllow'];
    }
  }

  Map<String, dynamic> toJson() => {
    'addLinkAllow': addLinkAllow,
    'addBeneficiaryAllow': addBeneficiaryAllow,
  };
}

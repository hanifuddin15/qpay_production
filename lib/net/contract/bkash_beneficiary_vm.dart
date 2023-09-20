class BkashViewModel{
  String name;
  String accountNumber;
  String proofToken;

  BkashViewModel(this.name, this.accountNumber,this.proofToken);

  BkashViewModel.fromJson(Map<String, dynamic> json) {
    if (json['name'] != null) {
      name = json['name']?.toString();
    }
    if (json['accountNumber'] != null) {
      accountNumber = json['accountNumber']?.toString();
    }
    if (json['proofToken'] != null) {
      proofToken = json['proofToken']?.toString();
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'accountNumber': accountNumber,
    'proofToken':proofToken,
  };
}
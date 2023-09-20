class ProofViewModel{
  String message;
  String token;
  String state;
  int expiresAt;

  ProofViewModel.fromJson(Map<String, dynamic> json){
    if (json['message'] != null) {
      message = json['message']?.toString();
    }
    if (json['token'] != null) {
      token = json['token']?.toString();
    }
    if (json['state'] != null) {
      state = json['state']?.toString();
    }
    if (json['expiresAt'] != null) {
      expiresAt = json['expiresAt'];
    }
  }
  bool isAccepted()=> state == 'Accepted';
  bool isVerified()=> state == 'Verified';
}

class ProofResponseViewModel{
  ProofViewModel proofViewModel;
  ProofResponseViewModel.fromJson(Map<String, dynamic> json){
    if (json['proof'] != null) {
      proofViewModel = ProofViewModel.fromJson(json['proof']);
    }
  }
}
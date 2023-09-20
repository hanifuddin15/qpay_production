class ForgetPasswordViewModel{
  String token;

  ForgetPasswordViewModel.fromJson(Map<String, dynamic> json) {
    if (json['token'] != null) {
      token = json['token']?.toString();
    }
  }
}
class TokenViewModel {
  String token;
  String refreshToken;
  DateTime expiryTime;


  TokenViewModel.fromJson(Map<String, dynamic> json) {
    if (json['access_token'] != null) {
      token = json['access_token']?.toString();
    }
    if (json['refresh_token'] != null) {
      refreshToken = json['refresh_token']?.toString();
    }
    if (json['expires_in'] != null) {
      var duration = int.parse(json['expires_in']?.toString());
      expiryTime = DateTime.now().add(new Duration(seconds: duration));
    }
  }
}

class UserRegisterDto {
  String mobileNumber;
  String operator;
  String vCode;
  String email;
  String vCodeEmail;
  String password;
  String deviceId;
  String deviceName;
  String deviceModel;
  String profileImage;
  String nidFrontImage;
  String nidBackImage;
  String nidNumber;


  UserRegisterDto(
      this.mobileNumber,
      this.operator,
      this.vCode,
      this.email,
      this.vCodeEmail,
      this.password,
      this.deviceId,
      this.deviceName,
      this.deviceModel,
      this.profileImage);
}

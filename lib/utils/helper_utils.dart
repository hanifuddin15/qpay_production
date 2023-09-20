class HelperUtils {
  static bool isInvalidPhoneNumber(String phone) {
    if (phone == null || phone.length != 11) return true;
    String pattern = r'(^01[3456789]{1}\d{8}$)';
    RegExp regExp = new RegExp(pattern);
    return !regExp.hasMatch(phone);
  }

  static bool isPersonNameInSmartCard(String name) {
    if (name == null || name.isEmpty) return false;
    String pattern = r'^[A-Z \d\W]+$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(name);
  }

  static bool isNumber(String text) {
    if (text == null || text.isEmpty) return false;
    String pattern = r'^[0-9 \d\W]+$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(text);
  }

  static bool isInvalidNidNumber(String nidNumber) {
    return nidNumber.length < 10 || nidNumber.length > 17;
  }

  static RegExp whiteSpaceRemovalExpression() {
    return RegExp(r"\s+");
  }

  static int defineOperatorFrom(String phoneNumber) {
    if (phoneNumber.startsWith("017") || phoneNumber.startsWith("013"))
      return 1;
    if (phoneNumber.startsWith("019") || phoneNumber.startsWith("014"))
      return 2;
    if (phoneNumber.startsWith("015")) return 3;
    if (phoneNumber.startsWith("016")) return 4;
    if (phoneNumber.startsWith("018")) return 5;
    return 0;
  }

  static String getPhoneNumberOnly(String phone) {
    if (phone!=null && phone.length >= 11) {
      var newString = phone.replaceAll(new RegExp(r'[^\d]+'),'');
      return newString.substring(newString.length - 11) ;
    }
    return phone;
  }

  static bool isInvalidEmailAddress(String email) {
    if (email == null) return true;
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    return !regExp.hasMatch(email);
  }

  static bool isPasswordCompliant(String password) {
    bool hasNotSimilarTwo = password.contains(new RegExp(r'(?!.*(?:(\d)\1|11|22|33|44|55|66|77|89|88|99|00))\d{6}'));
    bool hasDigits = password.contains(new RegExp(r'[1-9]{1}[0-9]{2}[^\\s-]{0,1}[0-9]{3}$'));
    bool hasNotSequential = password.contains(new RegExp(r'(?!.*(?:(\d)\1|123|234|345|456|567|678|789|890|321|432|543|654|765|876|987|098))\d{6}'));
    // bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasDigits & hasNotSimilarTwo & hasNotSequential;
  }

  static String amountFormatter(double amountDecimal) => amountDecimal.toStringAsFixed(
      amountDecimal.truncateToDouble() == amountDecimal ? 0 : 2);

  static String amountWithSymbol(String amount) => '৳'+amount;
}

class NidInformationParseViewModel{
  String nameEnglish;
  String nameBangla;
  String fathersName;
  String mothersName;
  String nidNumber;
  String dateOfBirth;

  NidInformationParseViewModel.fromJson(Map<String, dynamic> json){
    if (json['nameEnglish'] != null) {
      nameEnglish = json['nameEnglish']?.toString();
    }
    if (json['nameBangla'] != null) {
      nameBangla = json['nameBangla']?.toString();
    }
    if (json['fathersName'] != null) {
      fathersName = json['fathersName']?.toString();
    }
    if (json['mothersName'] != null) {
      mothersName = json['mothersName']?.toString();
    }
    if (json['nidNumber'] != null) {
      nidNumber = json['nidNumber']?.toString();
    }
    if (json['dateOfBirth'] != null) {
      dateOfBirth = json['dateOfBirth']?.toString();
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:qpay/net/contract/nid_information_parse_vm.dart';
import 'package:qpay/net/contract/nid_parse_information_dto.dart';
import 'package:qpay/providers/value_update_provider.dart';

class NidParseInformationProvider extends ChangeNotifier implements ValueHolderUpdateProvider{

  static final NidParseInformationProvider _singleton =
  NidParseInformationProvider._internal();

  factory NidParseInformationProvider() => _singleton;

  NidParseInformationProvider._internal();

  String nameEnglish;
  String nameBangla;
  String fathersName;
  String mothersName;
  String nidNumber;
  String dateOfBirth;
  String gender;

  NidParseInformationDto getNidInformationParseViewModel(){
    return NidParseInformationDto(nameEnglish, nameBangla,
        fathersName, mothersName, nidNumber,
        dateOfBirth,gender);
  }

  void setNameEnglish(String nameEng){
    nameEnglish = nameEng;
  }
  void setNameBangla(String nameBng){
    nameBangla = nameBng;
  }
  void setFathersName(String nameFather){
    fathersName = nameFather;
  }
  void setMothersName(String nameMother){
    mothersName = nameMother;
  }
  void setNidNumber(String nidNo){
    nidNumber = nidNo;
  }
  void setDateOfBirth(String dOB){
    dateOfBirth = dOB;
  }

  void setGender(String genderType){
    gender = genderType;
  }

  void setInformation(NidInformationParseViewModel nidInformationParseViewModel) async{
    nameEnglish = nidInformationParseViewModel.nameEnglish;
    nameBangla = nidInformationParseViewModel.nameBangla;
    fathersName = nidInformationParseViewModel.fathersName;
    mothersName = nidInformationParseViewModel.mothersName;
    nidNumber = nidInformationParseViewModel.nidNumber;
    dateOfBirth = nidInformationParseViewModel.dateOfBirth;
    notifyListeners();
  }

  @override
  void clear() {
    nameEnglish = null;
    nameBangla = null;
    fathersName = null;
    mothersName = null;
    nidNumber = null;
    dateOfBirth = null;
    gender = null;
  }
}
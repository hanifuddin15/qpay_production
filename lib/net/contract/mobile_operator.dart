class MobileOperator {
  int id;
  //only for view
  String name;
  String codeName;

  MobileOperator(this.id, this.name, this.codeName);

  static List<MobileOperator> getMobileOperators() {
    return <MobileOperator>[
      MobileOperator(0, 'Select Operator', "Operator"),
      MobileOperator(1, 'Grameen Phone', "GrameenPhone"),
      MobileOperator(2, 'Banglalink', "BanglaLink"),
      MobileOperator(3, 'Teletalk', "TeleTalk"),
      MobileOperator(4, 'Airtel', "Airtel"),
      MobileOperator(5, 'Robi', "Robi"),
    ];
  }
}

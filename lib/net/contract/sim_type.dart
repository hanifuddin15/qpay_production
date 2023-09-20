class SimType{
  int id;
  //only for view
  String name;
  String codeName;

  SimType(this.id, this.name, this.codeName);

  static List<SimType> getSimTypes() {
    return <SimType>[
      SimType(1, 'Prepaid', "Prepaid"),
      SimType(2, 'Postpaid', "Postpaid"),
      SimType(3, 'Skitto', "Skitto"),
    ];
  }

}
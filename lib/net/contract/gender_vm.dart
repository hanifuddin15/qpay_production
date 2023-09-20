class Gender{
  int id;
  String gender;
  Gender(this.id,this.gender);
  static List<Gender> getGenderTypes() {
    return <Gender>[
      Gender(0, 'Gender'),
      Gender(1, 'Male'),
      Gender(2, 'Female'),
    ];
  }
}
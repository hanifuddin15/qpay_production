class CardTypeData{
  int id;
  String name;

  CardTypeData(this.id, this.name);

  static List<CardTypeData> getCardTypes() {
    return <CardTypeData>[
      CardTypeData(1, 'Credit'),
      CardTypeData(2, 'Debit'),
      CardTypeData(3, 'Prepaid'),
    ];
  }

}
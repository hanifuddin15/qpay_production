class TransactionCategoryViewModel {
  String name;
  String id;
  String type;

  TransactionCategoryViewModel({this.name, this.id, this.type});

  TransactionCategoryViewModel.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    id = json['id']?.toString();
    type = json['type']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}

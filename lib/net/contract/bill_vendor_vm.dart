class BillVendorViewModel {
  String name;
  String imageUrl;
  int id;
  List<ConnectionTypes> connectionTypes;

  BillVendorViewModel({this.name, this.imageUrl, this.id, this.connectionTypes});

  BillVendorViewModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['imageUrl'];
    id = json['id'];
    if (json['connectionTypes'] != null) {
      connectionTypes = <ConnectionTypes>[];
      json['connectionTypes'].forEach((v) {
        connectionTypes.add(new ConnectionTypes.fromJson(v));
      });
    }
  }

  @override
  bool operator ==(Object other) {
   return other != null && other is BillVendorViewModel && this.id == other.id;
  }
  @override
  int get hashCode => super.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['id'] = this.id;
    if (this.connectionTypes != null) {
      data['connectionTypes'] =
          this.connectionTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConnectionTypes {
  int id;
  String name;

  ConnectionTypes({this.id, this.name});

  ConnectionTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  @override
  bool operator ==(Object other) => other!= null && other is ConnectionTypes && this.id == other.id;

  @override
  int get hashCode => super.hashCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
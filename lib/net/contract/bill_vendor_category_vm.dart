import 'package:qpay/net/contract/bill_vendor_vm.dart';

class BillVendorCategoryViewModel {
  int id;
  String name;
  String imageUrl;
  List<BillVendorViewModel> vendors = new List<BillVendorViewModel>();

  BillVendorCategoryViewModel(
      {this.id, this.name, this.imageUrl, this.vendors});

  BillVendorCategoryViewModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['imageUrl'];
    id = json['id'];
    if (json['vendors'] != null) {
      json['vendors'].forEach((v) {
        vendors.add(new BillVendorViewModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['id'] = this.id;
    if (this.vendors != null) {
      data['connectionTypes'] = this.vendors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

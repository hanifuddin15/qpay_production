class TransactionLimitViewModel {
  String name;
  AmountRange amountRange;
  Daily daily;
  Daily monthly;

  TransactionLimitViewModel({this.name, this.amountRange, this.daily, this.monthly});

  TransactionLimitViewModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amountRange = json['amountRange'] != null
        ? new AmountRange.fromJson(json['amountRange'])
        : null;
    daily = json['daily'] != null ? new Daily.fromJson(json['daily']) : null;
    monthly =
    json['monthly'] != null ? new Daily.fromJson(json['monthly']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.amountRange != null) {
      data['amountRange'] = this.amountRange.toJson();
    }
    if (this.daily != null) {
      data['daily'] = this.daily.toJson();
    }
    if (this.monthly != null) {
      data['monthly'] = this.monthly.toJson();
    }
    return data;
  }
}

class AmountRange {
  double min;
  double max;

  AmountRange({this.min, this.max});

  AmountRange.fromJson(Map<String, dynamic> json) {
    min = double.parse(json['min'].toString());
    max = double.parse(json['max'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min'] = this.min;
    data['max'] = this.max;
    return data;
  }
}

class Daily {
  Count count;
  Amount amount;

  Daily({this.count, this.amount});

  Daily.fromJson(Map<String, dynamic> json) {
    count = json['count'] != null ? new Count.fromJson(json['count']) : null;
    amount = json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.count != null) {
      data['count'] = this.count.toJson();
    }
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    return data;
  }
}

class Count {
  int current;
  int max;

  Count({this.current, this.max});

  Count.fromJson(Map<String, dynamic> json) {
    current = int.parse(json['current'].toString()) ;
    max = int.parse(json['max'].toString()) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current'] = this.current;
    data['max'] = this.max;
    return data;
  }
}

class Amount {
  double current;
  double max;

  Amount({this.current, this.max});

  Amount.fromJson(Map<String, dynamic> json) {
    current = double.parse(json['current'].toString()) ;
    max = double.parse(json['max'].toString()) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current'] = this.current;
    data['max'] = this.max;
    return data;
  }
}
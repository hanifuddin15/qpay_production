class CardStatusViewModel{
  String cardStatus;

  CardStatusViewModel.fromJson(Map<String, dynamic> json){
    if(json['status']!=null){
      cardStatus = json['status'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.cardStatus;
    return data;
  }
}
class NotificationCountViewModel{
  int count;

  NotificationCountViewModel.fromJson(Map<String, dynamic> json){
    if(json['count']!=null){
      count = json['count'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}
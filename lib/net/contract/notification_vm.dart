class NotificationViewModel{
  String title;
  String message;
  String type;

  NotificationViewModel.fromJson(Map<String, dynamic> json){
    if(json['title']!=null){
      title = json['title'];
    }
    if(json['message']!=null){
      message = json['message'];
    }
    if(json['type']!=null){
      type = json['type'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['type'] = this.type;
    return data;
  }
}
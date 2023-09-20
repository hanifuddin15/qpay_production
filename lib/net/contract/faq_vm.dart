class FAQViewModel{
  String title;
  String body;

  FAQViewModel.fromJson(Map<String, dynamic> json){
    if(json['title']!=null){
      title = json['title'];
    }
    if(json['body']!=null){
      body = json['body'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
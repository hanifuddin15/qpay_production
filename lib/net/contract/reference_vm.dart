class ReferenceViewModel{
  String referenceId;

  ReferenceViewModel.fromJson(Map<String, dynamic> json){
    if(json['referenceId']!=null){
      referenceId = json['referenceId'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referenceId'] = this.referenceId;
    return data;
  }
}
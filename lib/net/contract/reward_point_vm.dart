class RewardPointViewModel{
  String rewardPoint;

  RewardPointViewModel.fromJson(Map<String, dynamic> json){
    if(json['rewardPoint']!=null){
      rewardPoint = json['rewardPoint'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rewardPoint'] = this.rewardPoint;
    return data;
  }
}
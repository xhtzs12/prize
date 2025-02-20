class LotteryRequest {
  int uid;
  int type;
  String endTime;
  int joinLimit;
  int joinMethod;
  String textNotice;
  String imageNotice;
  String prize;

  // 构造函数
  LotteryRequest({
    this.uid = 0,
    this.type = 0,
    this.endTime = '',
    this.joinLimit = 0,
    this.joinMethod = 0,
    this.textNotice = '',
    this.imageNotice = '',
    this.prize = '',
  });

  // 从 JSON 数据中解析
  factory LotteryRequest.fromJson(Map<String, dynamic> json) {
    return LotteryRequest(
      uid: json['uid'],
      type: json['type'],
      endTime: json['endTime'],
      joinLimit: json['joinLimit'],
      joinMethod: json['joinMethod'],
      textNotice: json['textNotice'],
      imageNotice: json['imageNotice'],
      prize: json['prize'],
    );
  }

  // 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'type': type,
      'endTime': endTime,
      'joinLimit': joinLimit,
      'joinMethod': joinMethod,
      'textNotice': textNotice,
      'imageNotice': imageNotice,
      'prize': prize,
    };
  }

  @override
  String toString() {
    return 'LotteryRequest(uid: $uid, type: $type, endTime: $endTime, joinLimit: $joinLimit, joinMethod: $joinMethod, textNotice: $textNotice, imageNotice: $imageNotice, prize: $prize)';
  }
}

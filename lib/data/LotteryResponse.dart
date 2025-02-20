class LotteryResponse {
  int number;
  int start;
  int end;
  int id;
  String picture;

  LotteryResponse({
    this.number = 0,
    this.start = 0,
    this.end = 0,
    this.id = 0,
    this.picture = '',
  });

  // 从 JSON 数据中解析
  factory LotteryResponse.fromJson(Map<String, dynamic> json) {
    return LotteryResponse(
      number: json['number'],
      start: json['start'],
      end: json['end'],
      id: json['id'],
      picture: json['picture'],
    );
  }

  // 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'start': start,
      'end': end,
      'id': id,
      'picture': picture,
    };
  }

  @override
  String toString() {
    return 'LotteryResponse(number: $number, start: $start, end: $end, id: $id, picture: $picture)';
  }
}